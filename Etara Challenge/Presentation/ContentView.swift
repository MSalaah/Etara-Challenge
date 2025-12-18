//
//  ContentView.swift
//  Etara Challenge
//
//  Created by Moe Salah  on 17/12/2025.
//

import SwiftUI
import MapKit

// MARK: - Main Screen
struct ContentView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var currentDetent: PresentationDetent = .fraction(0.15)
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar and filters at the top
            VStack(spacing: 12) {
                TopSearchBar(
                    query: $viewModel.query,
                    location: viewModel.location,
                    onSearch: {
                        viewModel.search()
                    }
                )
                
                FiltersBar(
                    filters: viewModel.filters,
                    selected: viewModel.selectedFilter
                ) { filter in
                    viewModel.toggleFilter(filter)
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 8)
            .background(Color.black)
            
            // Map below the search and filters
            ZStack {
                Map(
                    coordinateRegion: Binding(
                        get: { viewModel.region.asMKCoordinateRegion },
                        set: { _ in }
                    ),
                    annotationItems: viewModel.restaurants
                ) { restaurant in
                    MapAnnotation(coordinate: restaurant.coordinate) {
                        Button {
                            viewModel.selectRestaurant(restaurant)
                            viewModel.updateRegionCenter(coordinate: restaurant.coordinate)
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .preferredColorScheme(.dark)
                
                // Loading indicator (non-blocking)
                if viewModel.isLoading {
                    VStack {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding(12)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(8)
                            Spacer()
                        }
                        Spacer()
                    }
                    .allowsHitTesting(false)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $viewModel.showResultsSheet) {
            RestaurantBottomSheet(
                restaurants: viewModel.restaurants,
                selectedRestaurant: $viewModel.selectedRestaurant,
                onSelectRestaurant: { restaurant in
                    viewModel.selectRestaurant(restaurant)
                    viewModel.updateRegionCenter(coordinate: restaurant.coordinate)
                }
            )
            .presentationDetents([.fraction(0.15), .medium, .large], selection: $currentDetent)
            .presentationDragIndicator(.visible)
            .presentationBackground(.ultraThinMaterial)
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
            .interactiveDismissDisabled()
            .onChange(of: viewModel.sheetDetent) { newValue in
                currentDetent = newValue.asPresentationDetent
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

// MARK: - Top Search Bar
struct TopSearchBar: View {
    @Binding var query: String
    let location: String
    let onSearch: () -> Void
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {}) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                
                VStack(alignment: .leading, spacing: 2) {
                    TextField("Search restaurants", text: $query)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .focused($isSearchFocused)
                        .submitLabel(.search)
                        .onSubmit {
                            onSearch()
                            isSearchFocused = false
                        }
                    
                    Text(location)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if !query.isEmpty {
                    Button(action: {
                        query = "Indian restaurants"
                        onSearch()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(white: 0.15))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

// MARK: - Filters Bar
struct FiltersBar: View {
    let filters: [Filter]
    let selected: Filter?
    let onSelect: (Filter) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filters) { filter in
                    FilterChip(
                        filter: filter,
                        isSelected: selected?.id == filter.id,
                        onTap: { onSelect(filter) }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let filter: Filter
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            if let icon = filter.icon {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .medium))
            }
            
            Text(filter.title)
                .font(.system(size: 14, weight: .medium))
            
            if filter.hasDropdown {
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .semibold))
            }
        }
        .foregroundColor(isSelected ? .white : .white.opacity(0.9))
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            isSelected
            ? Color.blue.opacity(0.8)
            : Color(white: 0.15)
        )
        .cornerRadius(20)
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Restaurant Bottom Sheet
struct RestaurantBottomSheet: View {
    let restaurants: [Restaurant]
    @Binding var selectedRestaurant: Restaurant?
    let onSelectRestaurant: (Restaurant) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            if let selected = selectedRestaurant {
                ScrollView {
                    RestaurantCard(restaurant: selected, isExpanded: true)
                        .padding(.horizontal)
                        .padding(.top, 8)
                }
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Over \(restaurants.count) restaurants")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top, 12)
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(restaurants) { restaurant in
                                RestaurantCard(restaurant: restaurant, isExpanded: false)
                                    .onTapGesture {
                                        onSelectRestaurant(restaurant)
                                    }
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

// MARK: - Restaurant Card
struct RestaurantCard: View {
    let restaurant: Restaurant
    let isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Restaurant Name and Rating
            VStack(alignment: .leading, spacing: 6) {
                Text(restaurant.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    HStack(spacing: 3) {
                        Text(String(format: "%.2f", restaurant.rating))
                            .font(.system(size: 14, weight: .medium))
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.white)
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Text(restaurant.cuisineType)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Text(restaurant.area)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            // Status
            HStack(spacing: 4) {
                Circle()
                    .fill(restaurant.isOpen ? Color.green : Color.red)
                    .frame(width: 8, height: 8)
                
                Text(restaurant.isOpen ? "Open now" : "Closed")
                    .font(.system(size: 13))
                    .foregroundColor(restaurant.isOpen ? .green : .red)
                
                Text("• Close \(restaurant.closingTime) • \(restaurant.distance)")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            // Images
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(restaurant.images, id: \.self) { imageName in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(white: 0.2))
                            .frame(width: 120, height: 90)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    }
                }
            }
            
            // Review
            HStack(spacing: 8) {
                Circle()
                    .fill(Color(white: 0.3))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    )
                
                Text("\"\(restaurant.review)\"")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            // Action Buttons
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.system(size: 14))
                        Text("Book now")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(white: 0.2))
                    .cornerRadius(8)
                }
                
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 14))
                        Text("Menu")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(white: 0.2))
                    .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color(white: 0.12))
        .cornerRadius(12)
    }
}

extension MapRegion {
    var asMKCoordinateRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude),
            span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        )
    }
    
    init(from mkRegion: MKCoordinateRegion) {
        self.centerLatitude = mkRegion.center.latitude
        self.centerLongitude = mkRegion.center.longitude
        self.latitudeDelta = mkRegion.span.latitudeDelta
        self.longitudeDelta = mkRegion.span.longitudeDelta
    }
}

extension SheetDetent {
    var asPresentationDetent: PresentationDetent {
        switch self {
        case .small:
            return .fraction(0.15)
        case .medium:
            return .medium
        case .large:
            return .large
        }
    }
}

#Preview {
    ContentView()
}
