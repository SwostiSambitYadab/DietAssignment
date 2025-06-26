//
//  NavigationRoute.swift
//  Diet Assignment
//
//  Created by hb on 26/06/25.
//

import SwiftUI

struct AnyScreen: Hashable {
    private let id: UUID = UUID()
    private let viewBuilder: () -> AnyView

    init<V: View>(_ view: V) {
        self.viewBuilder = { AnyView(view) }
    }

    func build() -> AnyView {
        viewBuilder()
    }

    static func == (lhs: AnyScreen, rhs: AnyScreen) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


final class NavRouter: ObservableObject {
    
    @Published var selectedTab: Tab? = nil
    
    @Published var eventRoutes = NavigationPath()
    @Published var couponRoutes = NavigationPath()
    @Published var homeRoutes = NavigationPath()
    @Published var rewardRoutes = NavigationPath()
    @Published var accountRoutes = NavigationPath()
    @Published var authRoutes = NavigationPath()
    
    func push(_ screen: AnyScreen) {
        switch selectedTab {
        case .event:
            debugPrint("Added event")
            eventRoutes.append(screen)
        case .coupon:
            debugPrint("Added coupon")
            couponRoutes.append(screen)
        case .home:
            debugPrint("Added Home")
            homeRoutes.append(screen)
        case .rewards:
            debugPrint("Added Rewards")
            rewardRoutes.append(screen)
        case .account:
            debugPrint("Added Account")
            accountRoutes.append(screen)
        case .none:
            debugPrint("Auth screen")
            authRoutes.append(screen)
        }
    }
    
    func pop() {
        switch selectedTab {
        case .event:
            if !eventRoutes.isEmpty { eventRoutes.removeLast() }
        case .coupon:
            if !couponRoutes.isEmpty { couponRoutes.removeLast() }
        case .home:
            if !homeRoutes.isEmpty { homeRoutes.removeLast() }
        case .rewards:
            if !rewardRoutes.isEmpty { rewardRoutes.removeLast() }
        case .account:
            if !accountRoutes.isEmpty { accountRoutes.removeLast() }
        case .none:
            if !authRoutes.isEmpty { authRoutes.removeLast() }
        }
    }
    
    func resetToRoot() {
        switch selectedTab {
        case .event:
            eventRoutes = NavigationPath()
        case .coupon:
            couponRoutes = NavigationPath()
        case .home:
            homeRoutes = NavigationPath()
        case .rewards:
            rewardRoutes = NavigationPath()
        case .account:
            accountRoutes = NavigationPath()
        case .none:
            authRoutes = NavigationPath()
        }
    }
}


enum Tab: Int, Identifiable, CaseIterable, Comparable {
    
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    case event, coupon, home, rewards, account
    
    internal var id: Int { rawValue }
    
    var icon: String  {
        switch self {
        case .event:
            return "event"
        case .coupon:
            return "coupon"
        case .home:
            return "home"
        case .rewards:
            return "rewards"
        case .account:
            return "account"
        }
    }
    
    var title: String {
        switch self {
        case .event:
            return "Events"
        case .coupon:
            return "Coupons"
        case .home:
            return ""
        case .rewards:
            return "Rewards"
        case .account:
            return "Account"
        }
    }
}

/// - UseCases:
///

//TabView(selection: $currentTab) {
//    NavigationStack(path: $nvrouter.eventRoutes) {
//        EventView(vm: .init(router: nvrouter))
//            .navigationDestination(for: AnyScreen.self) { screen in
//                screen.build()
//            }
//    }
//    .tag(0)
