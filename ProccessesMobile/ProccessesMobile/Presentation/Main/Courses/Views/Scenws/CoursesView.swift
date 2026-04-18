//
//  CoursesView.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import SwiftUI

struct CoursesView: View {
    @StateObject private var viewModel: CoursesViewModel
    @State private var isAddSheetPresented = false
    @State private var isSideMenuPresented = false

    init(viewModel: CoursesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            mainContent
                .disabled(isSideMenuPresented)
                .overlay {
                    if isSideMenuPresented {
                        Color.black.opacity(0.12)
                            .ignoresSafeArea()
                    }
                }
                .zIndex(0)

            if isSideMenuPresented {
                backdropLayer
                    .zIndex(1)

                sideMenuLayer
                    .zIndex(2)
            }
        }
        .task {
            await viewModel.onAppear()
        }
        .toolbar(isSideMenuPresented ? .hidden : .visible, for: .navigationBar)
        .animation(.easeInOut(duration: 0.22), value: isSideMenuPresented)
    }

    private var mainContent: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.courses) { course in
                        CourseCardView(course: course) {
                            viewModel.courseTapped(id: course.id)
                        }
                        .accessibilityIdentifier(AccessibilityID.Courses.courseCard(course.id))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }

            Button {
                isAddSheetPresented = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .frame(width: 56, height: 56)
            }
            .buttonStyle(.borderedProminent)
            .clipShape(Circle())
            .padding(.trailing, 20)
            .padding(.bottom, 20)
            .accessibilityIdentifier(AccessibilityID.Courses.addButton)
        }
        .navigationTitle("Classes")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if !isSideMenuPresented {
                    Button {
                        withAnimation(.easeInOut(duration: 0.22)) {
                            isSideMenuPresented = true
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                    .accessibilityIdentifier(AccessibilityID.Courses.menuButton)
                }
            }
        }
        .sheet(isPresented: $isAddSheetPresented) {
            CourseActionsSheet(
                onCreateCourse: {
                    isAddSheetPresented = false
                    DispatchQueue.main.async {
                        viewModel.createCourseTapped()
                    }
                },
                onJoinCourse: {
                    isAddSheetPresented = false
                    DispatchQueue.main.async {
                        viewModel.joinByCodeTapped()
                    }
                }
            )
            .presentationDetents([.height(220)])
            .presentationDragIndicator(.visible)
        }
    }

    private var backdropLayer: some View {
        Rectangle()
            .fill(Color.black.opacity(0.25))
            .ignoresSafeArea(.all)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.22)) {
                    isSideMenuPresented = false
                }
            }
            .accessibilityIdentifier(AccessibilityID.Courses.sideMenuBackdrop)
    }

    private var sideMenuLayer: some View {
        HStack(spacing: 0) {
            CoursesSideMenuView(
                currentUserInitial: viewModel.currentUserInitial,
                currentUserDisplayName: viewModel.currentUserDisplayName,
                teachingCourses: viewModel.teachingCourses,
                attendingCourses: viewModel.attendingCourses,
                onCourseTap: { courseId in
                    withAnimation(.easeInOut(duration: 0.22)) {
                        isSideMenuPresented = false
                    }
                    DispatchQueue.main.async {
                        viewModel.courseTapped(id: courseId)
                    }
                },
                onLogout: {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        isSideMenuPresented = false
                    }
                    DispatchQueue.main.async {
                        viewModel.logoutTapped()
                    }
                }
            )

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .ignoresSafeArea(.all)
        .transition(.move(edge: .leading))
    }
}
