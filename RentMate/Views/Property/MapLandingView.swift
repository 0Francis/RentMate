//
//  MapLandingView.swift
//  RentMate
//
//  Created by Student1 on 04/11/2025.
//


import SwiftUI
import MapKit

struct MapLandingView: View {
    @StateObject private var propertyVM = PropertyViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -1.2921, longitude: 36.8219),
        span: MKCoordinateSpan(latitudeDelta: 0.12, longitudeDelta: 0.12)
    )
    @State private var selectedProperty: PropertyModel? = nil
    @EnvironmentObject private var authVM: AuthViewModel
    @State private var showAuth = false

    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: propertyVM.properties) { property in
                    MapAnnotation(coordinate: property.location) {
                        VStack(spacing: 4) {
                            Image(systemName: "house.fill")
                                .font(.title3)
                                .padding(8)
                                .background(Color("RentMateBlueLight").opacity(0.9))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                                .onTapGesture {
                                    selectedProperty = property
                                }
                            Text(property.title).font(.caption).fixedSize()
                        }
                    }
                }
                .ignoresSafeArea()

                // Top overlay label
                VStack {
                    HStack {
                        Text("Explore properties")
                            .font(.headline)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                        Spacer()
                        Button(action: {
                            // quick reload or centering
                            propertyVM.fetchProperties()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    Spacer()
                }

                // Bottom CTA
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showAuth = true
                        }) {
                            Text("Get Started")
                                .bold()
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Discover")
            .sheet(item: $selectedProperty) { prop in
                PropertyDetailSheet(property: prop)
            }
            .fullScreenCover(isPresented: $showAuth) {
                LandingView()
                    .environmentObject(authVM)
            }
            .onAppear {
                propertyVM.fetchProperties()
            }
        }
    }
}

struct PropertyDetailSheet: View {
    let property: PropertyModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                Text(property.title).font(.title.bold())
                Text(property.address).foregroundColor(.secondary)
                Text("Rent: Ksh \(Int(property.rent))").font(.headline)
                Spacer()
            }
            .padding()
            .navigationTitle("Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
