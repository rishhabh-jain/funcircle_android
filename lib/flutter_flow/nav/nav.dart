import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';


import '/auth/base_auth_user_provider.dart';
import '/auth/profile_completion_guard.dart';

import '/backend/push_notifications/push_notifications_handler.dart'
    show PushNotificationsHandler;
import '/main.dart';
import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';
import '/mainscreens/my_profile/my_profile_widget.dart' as OldProfile;
import '/screens/profile/my_profile_widget.dart' as NewProfile;

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';
export '/backend/firebase_dynamic_links/firebase_dynamic_links.dart'
    show generateCurrentPageLink;

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => _RouteErrorBuilder(
        state: state,
        child: appStateNotifier.loggedIn
            ? ProfileCompletionGuard(child: NavBarPage())
            : WelcomeScreen(),
      ),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? ProfileCompletionGuard(child: NavBarPage())
              : WelcomeScreen(),
        ),
        FFRoute(
          name: OldProfile.MyProfileWidget.routeName,
          path: OldProfile.MyProfileWidget.routePath,
          builder: (context, params) => OldProfile.MyProfileWidget(),
        ),
        FFRoute(
          name: OthersProfileWidget.routeName,
          path: OthersProfileWidget.routePath,
          builder: (context, params) => OthersProfileWidget(
            uid: params.getParam(
              'uid',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: EditProfileWidget.routeName,
          path: EditProfileWidget.routePath,
          builder: (context, params) => EditProfileWidget(),
        ),
        FFRoute(
          name: SearchProfileWidget.routeName,
          path: SearchProfileWidget.routePath,
          builder: (context, params) => SearchProfileWidget(),
        ),
        FFRoute(
          name: SearchProfileFiltersWidget.routeName,
          path: SearchProfileFiltersWidget.routePath,
          builder: (context, params) => SearchProfileFiltersWidget(),
        ),
        FFRoute(
          name: ConnectionandgroupsWidget.routeName,
          path: ConnectionandgroupsWidget.routePath,
          builder: (context, params) => ConnectionandgroupsWidget(
            tabindex: params.getParam(
              'tabindex',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: SocialWidget.routeName,
          path: SocialWidget.routePath,
          builder: (context, params) => SocialWidget(
            tabindex: params.getParam(
              'tabindex',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: ViewGroupWidget.routeName,
          path: ViewGroupWidget.routePath,
          requireAuth: true,
          builder: (context, params) => ViewGroupWidget(
            groupid: params.getParam(
              'groupid',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: RecommendedWidget.routeName,
          path: RecommendedWidget.routePath,
          builder: (context, params) => RecommendedWidget(),
        ),
        FFRoute(
          name: PremiumWidget.routeName,
          path: PremiumWidget.routePath,
          builder: (context, params) => PremiumWidget(),
        ),
        FFRoute(
          name: CreateGroupWidget.routeName,
          path: CreateGroupWidget.routePath,
          builder: (context, params) => CreateGroupWidget(),
        ),
        FFRoute(
          name: CompleteProfilePageWidget.routeName,
          path: CompleteProfilePageWidget.routePath,
          builder: (context, params) => CompleteProfilePageWidget(),
        ),
        FFRoute(
          name: NameWidget.routeName,
          path: NameWidget.routePath,
          builder: (context, params) => NameWidget(
            location: params.getParam(
              'location',
              ParamType.LatLng,
            ),
          ),
        ),
        // New Auth Screens
        FFRoute(
          name: WelcomeScreen.routeName,
          path: WelcomeScreen.routePath,
          builder: (context, params) => WelcomeScreen(),
        ),
        FFRoute(
          name: PhoneAuthScreen.routeName,
          path: PhoneAuthScreen.routePath,
          builder: (context, params) => PhoneAuthScreen(),
        ),
        FFRoute(
          name: OtpVerificationScreen.routeName,
          path: OtpVerificationScreen.routePath,
          builder: (context, params) => OtpVerificationScreen(
            phoneNumber: params.getParam(
              'phoneNumber',
              ParamType.String,
            ),
          ),
        ),
        // Profile Setup Screens
        FFRoute(
          name: BasicInfoScreen.routeName,
          path: BasicInfoScreen.routePath,
          builder: (context, params) => BasicInfoScreen(),
        ),
        FFRoute(
          name: SportsSelectionScreen.routeName,
          path: SportsSelectionScreen.routePath,
          builder: (context, params) => SportsSelectionScreen(
            name: params.getParam(
              'name',
              ParamType.String,
            ),
            gender: params.getParam(
              'gender',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AddImagesWidget.routeName,
          path: AddImagesWidget.routePath,
          builder: (context, params) => AddImagesWidget(),
        ),
        FFRoute(
          name: DrinkWidget.routeName,
          path: DrinkWidget.routePath,
          builder: (context, params) => DrinkWidget(
            uid: params.getParam(
              'uid',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: WorkandeducationWidget.routeName,
          path: WorkandeducationWidget.routePath,
          builder: (context, params) => WorkandeducationWidget(
            workTitle: params.getParam(
              'workTitle',
              ParamType.String,
            ),
            company: params.getParam(
              'company',
              ParamType.String,
            ),
            college: params.getParam(
              'college',
              ParamType.String,
            ),
            graduationyear: params.getParam(
              'graduationyear',
              ParamType.String,
            ),
            uid: params.getParam(
              'uid',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: DoyousmokeWidget.routeName,
          path: DoyousmokeWidget.routePath,
          builder: (context, params) => DoyousmokeWidget(
            uid: params.getParam(
              'uid',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ReligionWidget.routeName,
          path: ReligionWidget.routePath,
          builder: (context, params) => ReligionWidget(),
        ),
        FFRoute(
          name: MotherTungueWidget.routeName,
          path: MotherTungueWidget.routePath,
          builder: (context, params) => MotherTungueWidget(
            uid: params.getParam(
              'uid',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: LookingforWidget.routeName,
          path: LookingforWidget.routePath,
          builder: (context, params) => LookingforWidget(
            uid: params.getParam(
              'uid',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: HometownWidget.routeName,
          path: HometownWidget.routePath,
          builder: (context, params) => HometownWidget(
            uid: params.getParam(
              'uid',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: HeightWidget.routeName,
          path: HeightWidget.routePath,
          builder: (context, params) => HeightWidget(
            uid: params.getParam(
              'uid',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PoliticalLeaningsWidget.routeName,
          path: PoliticalLeaningsWidget.routePath,
          builder: (context, params) => PoliticalLeaningsWidget(
            uid: params.getParam(
              'uid',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: WorkoutWidget.routeName,
          path: WorkoutWidget.routePath,
          builder: (context, params) => WorkoutWidget(
            uid: params.getParam(
              'uid',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ZodiacWidget.routeName,
          path: ZodiacWidget.routePath,
          builder: (context, params) => ZodiacWidget(
            uid: params.getParam(
              'uid',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: BioWidget.routeName,
          path: BioWidget.routePath,
          builder: (context, params) => BioWidget(
            uid: params.getParam(
              'uid',
              ParamType.String,
            ),
            biotext: params.getParam(
              'biotext',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: InterestsWidget.routeName,
          path: InterestsWidget.routePath,
          builder: (context, params) => InterestsWidget(
            uid: params.getParam(
              'uid',
              ParamType.String,
            ),
            filters: params.getParam(
              'filters',
              ParamType.bool,
            ),
            groupid: params.getParam(
              'groupid',
              ParamType.int,
            ),
            ifonlyfogroups: params.getParam(
              'ifonlyfogroups',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: PromptsWidget.routeName,
          path: PromptsWidget.routePath,
          builder: (context, params) => PromptsWidget(
            fromeditprofile: params.getParam(
              'fromeditprofile',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: AnswerpromptWidget.routeName,
          path: AnswerpromptWidget.routePath,
          builder: (context, params) => AnswerpromptWidget(
            questionText: params.getParam(
              'questionText',
              ParamType.String,
            ),
            promptid: params.getParam(
              'promptid',
              ParamType.int,
            ),
            answertext: params.getParam(
              'answertext',
              ParamType.String,
            ),
            fromeditProfile: params.getParam(
              'fromeditProfile',
              ParamType.bool,
            ),
            questionisset: params.getParam(
              'questionisset',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: ChatWidget.routeName,
          path: ChatWidget.routePath,
          asyncParams: {
            'chatUser': getDoc(['users'], UsersRecord.fromSnapshot),
          },
          builder: (context, params) => ChatWidget(
            chatUser: params.getParam(
              'chatUser',
              ParamType.Document,
            ),
            chatRef: params.getParam(
              'chatRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['chats'],
            ),
          ),
        ),
        FFRoute(
          name: AllchatsWidget.routeName,
          path: AllchatsWidget.routePath,
          builder: (context, params) => AllchatsWidget(),
        ),
        FFRoute(
          name: PaymentsuccessWidget.routeName,
          path: PaymentsuccessWidget.routePath,
          builder: (context, params) => PaymentsuccessWidget(
            amount: params.getParam(
              'amount',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: GroupfiltersWidget.routeName,
          path: GroupfiltersWidget.routePath,
          builder: (context, params) => GroupfiltersWidget(
            tabindex: params.getParam(
              'tabindex',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: LikedusersWidget.routeName,
          path: LikedusersWidget.routePath,
          builder: (context, params) => LikedusersWidget(),
        ),
        FFRoute(
          name: SettingsWidget.routeName,
          path: SettingsWidget.routePath,
          builder: (context, params) => SettingsWidget(),
        ),
        FFRoute(
          name: HelpcenterWidget.routeName,
          path: HelpcenterWidget.routePath,
          builder: (context, params) => HelpcenterWidget(),
        ),
        FFRoute(
          name: WebviewWidget.routeName,
          path: WebviewWidget.routePath,
          builder: (context, params) => WebviewWidget(
            url: params.getParam(
              'url',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AccesslocationWidget.routeName,
          path: AccesslocationWidget.routePath,
          builder: (context, params) => AccesslocationWidget(),
        ),
        FFRoute(
          name: CreateticketsWidget.routeName,
          path: CreateticketsWidget.routePath,
          builder: (context, params) => CreateticketsWidget(
            groupId: params.getParam(
              'groupId',
              ParamType.int,
            ),
            groupName: params.getParam(
              'groupName',
              ParamType.String,
            ),
            ifMyGroups: params.getParam(
              'ifMyGroups',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: MygroupsWidget.routeName,
          path: MygroupsWidget.routePath,
          builder: (context, params) => MygroupsWidget(),
        ),
        FFRoute(
          name: BookticketsWidget.routeName,
          path: BookticketsWidget.routePath,
          builder: (context, params) => BookticketsWidget(
            groupid: params.getParam(
              'groupid',
              ParamType.int,
            ),
            groupname: params.getParam(
              'groupname',
              ParamType.String,
            ),
            ticketid: params.getParam(
              'ticketid',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: MyticketWidget.routeName,
          path: MyticketWidget.routePath,
          builder: (context, params) => MyticketWidget(
            ticketid: params.getParam(
              'ticketid',
              ParamType.int,
            ),
            orderid: params.getParam(
              'orderid',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: MyticketsWidget.routeName,
          path: MyticketsWidget.routePath,
          builder: (context, params) => MyticketsWidget(),
        ),
        FFRoute(
          name: EditgroupsWidget.routeName,
          path: EditgroupsWidget.routePath,
          builder: (context, params) => EditgroupsWidget(
            groupid: params.getParam(
              'groupid',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: GroupordatingWidget.routeName,
          path: GroupordatingWidget.routePath,
          builder: (context, params) => GroupordatingWidget(),
        ),
        FFRoute(
          name: LikesbyrecommendedWidget.routeName,
          path: LikesbyrecommendedWidget.routePath,
          builder: (context, params) => LikesbyrecommendedWidget(),
        ),
        FFRoute(
          name: RequestsWidget.routeName,
          path: RequestsWidget.routePath,
          builder: (context, params) => RequestsWidget(
            groupId: params.getParam(
              'groupId',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: PostrequestWidget.routeName,
          path: PostrequestWidget.routePath,
          builder: (context, params) => PostrequestWidget(
            groupId: params.getParam(
              'groupId',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: MyrequestsWidget.routeName,
          path: MyrequestsWidget.routePath,
          builder: (context, params) => MyrequestsWidget(),
        ),
        FFRoute(
          name: InterestedpeopleWidget.routeName,
          path: InterestedpeopleWidget.routePath,
          builder: (context, params) => InterestedpeopleWidget(
            requestid: params.getParam(
              'requestid',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: MyinterestedrequestsWidget.routeName,
          path: MyinterestedrequestsWidget.routePath,
          builder: (context, params) => MyinterestedrequestsWidget(),
        ),
        FFRoute(
          name: CreateticketgroupsWidget.routeName,
          path: CreateticketgroupsWidget.routePath,
          builder: (context, params) => CreateticketgroupsWidget(
            groupId: params.getParam(
              'groupId',
              ParamType.int,
            ),
            ticketId: params.getParam(
              'ticketId',
              ParamType.int,
            ),
            isRsvp: params.getParam(
              'isRsvp',
              ParamType.bool,
            ),
            isclone: params.getParam(
              'isclone',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: SeewhojoinedWidget.routeName,
          path: SeewhojoinedWidget.routePath,
          builder: (context, params) => SeewhojoinedWidget(
            ticketid: params.getParam(
              'ticketid',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: TicketwebviewWidget.routeName,
          path: TicketwebviewWidget.routePath,
          builder: (context, params) => TicketwebviewWidget(),
        ),
        FFRoute(
          name: SecretfieldsWidget.routeName,
          path: SecretfieldsWidget.routePath,
          builder: (context, params) => SecretfieldsWidget(),
        ),
        FFRoute(
          name: ReportaglitchWidget.routeName,
          path: ReportaglitchWidget.routePath,
          builder: (context, params) => ReportaglitchWidget(
            uid: params.getParam(
              'uid',
              ParamType.String,
            ),
            biotext: params.getParam(
              'biotext',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: SalesWidget.routeName,
          path: SalesWidget.routePath,
          builder: (context, params) => SalesWidget(
            ticketid: params.getParam<int>(
              'ticketid',
              ParamType.int,
              isList: true,
            ),
          ),
        ),
        FFRoute(
          name: CreatevenueWidget.routeName,
          path: CreatevenueWidget.routePath,
          builder: (context, params) => CreatevenueWidget(),
        ),
        FFRoute(
          name: EditTicketWidget.routeName,
          path: EditTicketWidget.routePath,
          builder: (context, params) => EditTicketWidget(
            ticketId: params.getParam(
              'ticketId',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: SendNotificationWidget.routeName,
          path: SendNotificationWidget.routePath,
          builder: (context, params) => SendNotificationWidget(),
        ),
        FFRoute(
          name: SlotsWidget.routeName,
          path: SlotsWidget.routePath,
          builder: (context, params) => SlotsWidget(
            groupid: params.getParam(
              'groupid',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: SubscriptionquestionsWidget.routeName,
          path: SubscriptionquestionsWidget.routePath,
          builder: (context, params) => SubscriptionquestionsWidget(),
        ),
        FFRoute(
          name: HomepagewebviewWidget.routeName,
          path: HomepagewebviewWidget.routePath,
          builder: (context, params) => HomepagewebviewWidget(
            url: params.getParam(
              'url',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PlayWidget.routeName,
          path: PlayWidget.routePath,
          builder: (context, params) => PlayWidget(),
        ),
        FFRoute(
          name: VenuesWidget.routeName,
          path: VenuesWidget.routePath,
          builder: (context, params) => VenuesWidget(),
        ),
        FFRoute(
          name: ProfileWidget.routeName,
          path: ProfileWidget.routePath,
          builder: (context, params) => ProfileWidget(),
        ),
        FFRoute(
          name: MygroupswebWidget.routeName,
          path: MygroupswebWidget.routePath,
          builder: (context, params) => MygroupswebWidget(),
        ),
        FFRoute(
          name: BookingswebWidget.routeName,
          path: BookingswebWidget.routePath,
          builder: (context, params) => BookingswebWidget(),
        ),
        FFRoute(
          name: DuoconnectionswebWidget.routeName,
          path: DuoconnectionswebWidget.routePath,
          builder: (context, params) => DuoconnectionswebWidget(),
        ),
        FFRoute(
          name: RequestswebWidget.routeName,
          path: RequestswebWidget.routePath,
          builder: (context, params) => RequestswebWidget(),
        ),
        FFRoute(
          name: EditprofilewebWidget.routeName,
          path: EditprofilewebWidget.routePath,
          builder: (context, params) => EditprofilewebWidget(),
        ),
        FFRoute(
          name: HomeNewWidget.routeName,
          path: HomeNewWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'HomeNew')
              : HomeNewWidget(),
        ),
        FFRoute(
          name: VenuesNewWidget.routeName,
          path: VenuesNewWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'VenuesNew')
              : VenuesNewWidget(),
        ),
        FFRoute(
          name: VenueBookingWidget.routeName,
          path: VenueBookingWidget.routePath,
          builder: (context, params) => VenueBookingWidget(),
        ),
        FFRoute(
          name: SingleVenueNewWidget.routeName,
          path: SingleVenueNewWidget.routePath,
          builder: (context, params) => SingleVenueNewWidget(
            venueid: params.getParam(
              'venueid',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: PlaynewWidget.routeName,
          path: PlaynewWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'playnew')
              : PlaynewWidget(),
        ),
        FFRoute(
          name: FindPlayersNewWidget.routeName,
          path: FindPlayersNewWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'findPlayersNew')
              : FindPlayersNewWidget(),
        ),
        FFRoute(
          name: ChatsnewWidget.routeName,
          path: ChatsnewWidget.routePath,
          builder: (context, params) => ChatsnewWidget(),
        ),
        FFRoute(
          name: ChatRoomWidget.routeName,
          path: ChatRoomWidget.routePath,
          builder: (context, params) => ChatRoomWidget(
            roomId: params.getParam(
              'roomId',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ChatRoomInfoWidget.routeName,
          path: ChatRoomInfoWidget.routePath,
          builder: (context, params) => ChatRoomInfoWidget(
            roomId: params.getParam(
              'roomId',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PlayerNewWidget.routeName,
          path: PlayerNewWidget.routePath,
          builder: (context, params) => PlayerNewWidget(),
        ),
        FFRoute(
          name: DuorequestsnewWidget.routeName,
          path: DuorequestsnewWidget.routePath,
          builder: (context, params) => DuorequestsnewWidget(),
        ),
        // Old login removed - redirect to welcome screen
        FFRoute(
          name: 'Login',
          path: '/loginNew',
          builder: (context, params) => WelcomeScreen(),
        ),
        FFRoute(
          name: ProfileMenuWidget.routeName,
          path: ProfileMenuWidget.routePath,
          builder: (context, params) => ProfileMenuWidget(),
        ),
        FFRoute(
          name: MoreOptionsWidget.routeName,
          path: MoreOptionsWidget.routePath,
          builder: (context, params) => MoreOptionsWidget(),
        ),
        FFRoute(
          name: SettingsScreenWidget.routeName,
          path: SettingsScreenWidget.routePath,
          builder: (context, params) => SettingsScreenWidget(),
        ),
        FFRoute(
          name: ContactSupportWidget.routeName,
          path: ContactSupportWidget.routePath,
          builder: (context, params) => ContactSupportWidget(),
        ),
        FFRoute(
          name: PolicyWidget.routeName,
          path: PolicyWidget.routePath,
          builder: (context, params) => PolicyWidget(
            policyType: params.getParam(
              'policyType',
              ParamType.String,
            ) ?? 'privacy',
          ),
        ),
        FFRoute(
          name: MyBookingsWidget.routeName,
          path: MyBookingsWidget.routePath,
          builder: (context, params) => MyBookingsWidget(),
        ),
        FFRoute(
          name: GameRequestsWidget.routeName,
          path: GameRequestsWidget.routePath,
          builder: (context, params) => GameRequestsWidget(),
        ),
        FFRoute(
          name: MyPlayFriendsWidget.routeName,
          path: MyPlayFriendsWidget.routePath,
          builder: (context, params) => MyPlayFriendsWidget(),
        ),
        FFRoute(
          name: NotificationsScreenWidget.routeName,
          path: NotificationsScreenWidget.routePath,
          builder: (context, params) => NotificationsScreenWidget(),
        ),
        FFRoute(
          name: ReferralsScreenWidget.routeName,
          path: ReferralsScreenWidget.routePath,
          builder: (context, params) => ReferralsScreenWidget(),
        ),
        FFRoute(
          name: NewProfile.MyProfileWidget.routeName,
          path: NewProfile.MyProfileWidget.routePath,
          builder: (context, params) => NewProfile.MyProfileWidget(),
        ),
        // Organizer feature routes
        FFRoute(
          name: BecomeOrganizerIntroPage.routeName,
          path: BecomeOrganizerIntroPage.routePath,
          builder: (context, params) => BecomeOrganizerIntroPage(),
        ),
        FFRoute(
          name: OrganizerApplicationPage.routeName,
          path: OrganizerApplicationPage.routePath,
          builder: (context, params) => OrganizerApplicationPage(),
        ),
        FFRoute(
          name: AdminOrganizerPanel.routeName,
          path: AdminOrganizerPanel.routePath,
          builder: (context, params) => AdminOrganizerPanel(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
      observers: [routeObserver],
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/onboarding';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? isWeb
                  ? Container()
                  : Container(
                      color: Colors.transparent,
                      child: Image.asset(
                        'assets/images/faceout_(4).png',
                        fit: BoxFit.cover,
                      ),
                    )
              : PushNotificationsHandler(child: page);

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class _RouteErrorBuilder extends StatefulWidget {
  const _RouteErrorBuilder({
    Key? key,
    required this.state,
    required this.child,
  }) : super(key: key);

  final GoRouterState state;
  final Widget child;

  @override
  State<_RouteErrorBuilder> createState() => _RouteErrorBuilderState();
}

class _RouteErrorBuilderState extends State<_RouteErrorBuilder> {
  @override
  void initState() {
    super.initState();

    // Handle erroneous links from Firebase Dynamic Links.

    String? location;

    /*
    Handle `links` routes that have dynamic-link entangled with deep-link 
    */
    if (widget.state.uri.toString().startsWith('/link') &&
        widget.state.uri.queryParameters.containsKey('deep_link_id')) {
      final deepLinkId = widget.state.uri.queryParameters['deep_link_id'];
      if (deepLinkId != null) {
        final deepLinkUri = Uri.parse(deepLinkId);
        final link = deepLinkUri.toString();
        final host = deepLinkUri.host;
        location = link.split(host).last;
      }
    }

    if (widget.state.uri.toString().startsWith('/link') &&
        widget.state.uri.toString().contains('request_ip_version')) {
      location = '/';
    }

    if (location != null) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => context.go(location!));
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
