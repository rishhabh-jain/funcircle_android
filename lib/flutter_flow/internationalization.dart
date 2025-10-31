import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'hi'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? hiText = '',
  }) =>
      [enText, hiText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // onboarding
  {
    '04ji0tdf': {
      'en': 'Play without hassle',
      'hi': '',
    },
    'o2xabzc1': {
      'en': 'Login',
      'hi': '',
    },
    'aj9lfsvr': {
      'en': 'Signup',
      'hi': '',
    },
    '80kunuci': {
      'en': 'By signing up, you agree to our ',
      'hi': '',
    },
    'nwyfmkn8': {
      'en': 'Terms.',
      'hi': '',
    },
    'u9yqe1kg': {
      'en': 'See how we use your data in our ',
      'hi': '',
    },
    'aykz7ogc': {
      'en': 'Privacy Policy.',
      'hi': '',
    },
    'm2ypwupj': {
      'en': 'Home',
      'hi': '',
    },
  },
  // myProfile
  {
    'ap1cgnd4': {
      'en': 'More',
      'hi': '',
    },
    '2sgfz5r4': {
      'en': 'Groups',
      'hi': '',
    },
    'aemtiua5': {
      'en': 'My Bookings',
      'hi': '',
    },
    'y18bvw8p': {
      'en': 'Event Bookings',
      'hi': '',
    },
    'n5zeijd8': {
      'en': 'Joined Groups / Chats',
      'hi': '',
    },
    'js7b95t3': {
      'en': 'View joined groups',
      'hi': '',
    },
    'k2mfdst8': {
      'en': 'Mains',
      'hi': '',
    },
    'znpj9yg1': {
      'en': 'Game Requests',
      'hi': '',
    },
    '8zgvrth0': {
      'en': 'Go together for playing',
      'hi': '',
    },
    'hmkj2kay': {
      'en': 'My Duo Connections',
      'hi': '',
    },
    'm9if2v7u': {
      'en': 'Your sports partner',
      'hi': '',
    },
    'oqgno7of': {
      'en': 'My Profile',
      'hi': '',
    },
    'xhyhts6m': {
      'en': 'Update profile',
      'hi': '',
    },
    '6v95kitg': {
      'en': 'Others',
      'hi': '',
    },
    '31o6quqa': {
      'en': 'Notifications',
      'hi': '',
    },
    '9pt0dpqw': {
      'en': 'Email / SMS / Push notifications',
      'hi': '',
    },
    '4bjxvxr3': {
      'en': 'Contact Support',
      'hi': '',
    },
    '991y9xre': {
      'en': 'Via Whatsapp, Calls',
      'hi': '',
    },
    '57j2e7j8': {
      'en': 'Policies',
      'hi': '',
    },
    'vd03lcab': {
      'en': 'All policies / Delete Account',
      'hi': '',
    },
    '8csu7za0': {
      'en': 'More',
      'hi': '',
    },
  },
  // othersProfile
  {
    'x7auousy': {
      'en': 'Explore groups and events \nvia Facesocial',
      'hi': '',
    },
    'wv9gt35e': {
      'en': 'Go Social',
      'hi': '',
    },
    'p98xf82k': {
      'en': 'Send message directly',
      'hi': '',
    },
    'kdyvyq7u': {
      'en': 'Message',
      'hi': '',
    },
    'i7tqz94h': {
      'en': 'Liked',
      'hi': '',
    },
    'aiwsakgg': {
      'en': 'Connected',
      'hi': '',
    },
    'totplu6g': {
      'en': 'Like',
      'hi': '',
    },
    'iqzflz9a': {
      'en': 'Add Connection',
      'hi': '',
    },
    'mb3ea98v': {
      'en': 'My basics',
      'hi': '',
    },
    'ijjvcrov': {
      'en': 'Dogs',
      'hi': '',
    },
    'b5x1gio8': {
      'en': 'My Interest',
      'hi': '',
    },
    '07wxk6ft': {
      'en': 'Art',
      'hi': '',
    },
    'wa7swn3w': {
      'en': 'Museums & galleries',
      'hi': '',
    },
    '2kofateo': {
      'en': 'Coffee',
      'hi': '',
    },
    'ml3zz5r0': {
      'en': 'Cat',
      'hi': '',
    },
    '6mm2cq49': {
      'en': 'Movie',
      'hi': '',
    },
    'm9yi521l': {
      'en': 'Dog',
      'hi': '',
    },
    'n9zhyvdz': {
      'en': 'Travel',
      'hi': '',
    },
    'nb7c37mz': {
      'en': 'Pictures',
      'hi': '',
    },
    'lxac18f4': {
      'en': 'Secret fields',
      'hi': '',
    },
    '4qnhqo93': {
      'en': 'Secret to my heart is',
      'hi': '',
    },
    'kp194jy3': {
      'en': 'Private thoughts',
      'hi': '',
    },
    '1xp0p1r2': {
      'en': 'Exclusive insights',
      'hi': '',
    },
    'gxbh8w0f': {
      'en': 'Liked',
      'hi': '',
    },
    'ci70rnao': {
      'en': 'Connected',
      'hi': '',
    },
    'waglr8xx': {
      'en': 'Like',
      'hi': '',
    },
    'dvo65iab': {
      'en': 'Add Connection',
      'hi': '',
    },
    'tj335ia2': {
      'en': 'Recommend to a friend',
      'hi': '',
    },
    'y6yk6ovj': {
      'en': 'Faceout',
      'hi': '',
    },
    '752zth2v': {
      'en': 'Home',
      'hi': '',
    },
  },
  // editProfile
  {
    '53zxku6l': {
      'en': 'PROFILE COMPLETED',
      'hi': '',
    },
    '50moxtr9': {
      'en': 'Photos and videos',
      'hi': '',
    },
    'ss30ojk6': {
      'en': 'Hold and drag to main image',
      'hi': '',
    },
    'rxmsqoaq': {
      'en': 'Primary',
      'hi': '',
    },
    'g1zttun4': {
      'en': 'Set as Primary',
      'hi': '',
    },
    'zqu5ybmj': {
      'en': 'Set as Primary',
      'hi': '',
    },
    '01m52ck0': {
      'en': 'Set as Primary',
      'hi': '',
    },
    'mqtr7fmh': {
      'en': 'Set as Primary',
      'hi': '',
    },
    '4lo8nalg': {
      'en': 'Save Images',
      'hi': '',
    },
    'orebx3co': {
      'en': 'Open for dating',
      'hi': '',
    },
    '8s797tw9': {
      'en': 'My Bio',
      'hi': '',
    },
    '8wesaxpk': {
      'en': 'Write a punchy intro',
      'hi': '',
    },
    'ouo18nol': {
      'en': 'My Interest',
      'hi': '',
    },
    'sqbpaklh': {
      'en': 'Art',
      'hi': '',
    },
    't4q3pmr0': {
      'en': 'Museums & galleries',
      'hi': '',
    },
    'qzftpwug': {
      'en': 'Coffee',
      'hi': '',
    },
    'paswapvl': {
      'en': 'Cat',
      'hi': '',
    },
    '9qi9moae': {
      'en': 'Movie',
      'hi': '',
    },
    '4nadjekp': {
      'en': 'Dog',
      'hi': '',
    },
    '3xythmei': {
      'en': 'Travel',
      'hi': '',
    },
    'psrc8ozx': {
      'en': 'Profile prompts',
      'hi': '',
    },
    '5yzt8cbx': {
      'en': 'Make your personality stand out',
      'hi': '',
    },
    'cglzsbjd': {
      'en': 'Add New',
      'hi': '',
    },
    'cd5thuca': {
      'en': 'My basics',
      'hi': '',
    },
    '92hw7gci': {
      'en': 'Work & Education',
      'hi': '',
    },
    '5s223muw': {
      'en': 'Add',
      'hi': '',
    },
    'y2b4yld9': {
      'en': 'Location',
      'hi': '',
    },
    'bfdsn86w': {
      'en': 'Looking for ',
      'hi': '',
    },
    'rcjcn8vo': {
      'en': 'Drinking',
      'hi': '',
    },
    'bfzsak1i': {
      'en': 'Religion',
      'hi': '',
    },
    'xbm1r1ol': {
      'en': 'Smoking',
      'hi': '',
    },
    '9b7jipvc': {
      'en': 'More about me ',
      'hi': '',
    },
    'rxkatr9o': {
      'en': 'Cover this things most people want to know about.',
      'hi': '',
    },
    'lbc957kt': {
      'en': 'Workout',
      'hi': '',
    },
    'ltzrrdws': {
      'en': 'Height',
      'hi': '',
    },
    'zurpizrd': {
      'en': 'Zodiac',
      'hi': '',
    },
    '5s01gk35': {
      'en': 'Political Leanings',
      'hi': '',
    },
    '9zt6o38t': {
      'en': 'Hometown',
      'hi': '',
    },
    'r4l4xjme': {
      'en': 'Pets',
      'hi': '',
    },
    '7ct3q3rd': {
      'en': 'Add',
      'hi': '',
    },
    '6u57fpnf': {
      'en': 'Enhance your profile ✨ ',
      'hi': '',
    },
    'x6dbpopw': {
      'en': 'Mother Tungue',
      'hi': '',
    },
    'gputpppl': {
      'en': 'English',
      'hi': '',
    },
    'f3bfsgkr': {
      'en': 'Hindi',
      'hi': '',
    },
    'akm3klxf': {
      'en': 'Edit profile',
      'hi': '',
    },
    '1natbok0': {
      'en': 'Home',
      'hi': '',
    },
  },
  // searchProfile
  {
    'xqcuyy9h': {
      'en': 'Search',
      'hi': '',
    },
    'ecmje8r8': {
      'en': 'Set preferences',
      'hi': '',
    },
    'i996c4rk': {
      'en': 'Users based on your search',
      'hi': '',
    },
    'qu7u754o': {
      'en': 'Age',
      'hi': '',
    },
    'cnh75hni': {
      'en': 'Height',
      'hi': '',
    },
    '0qkt2h26': {
      'en': 'Languages',
      'hi': '',
    },
    '6hx948jo': {
      'en': 'Hindi',
      'hi': '',
    },
    'yyqy7s96': {
      'en': 'English',
      'hi': '',
    },
    'rk2j2s0k': {
      'en': 'Marathi',
      'hi': '',
    },
    'bqv3xjk4': {
      'en': 'Telegu',
      'hi': '',
    },
    '0j7fqypp': {
      'en': 'Tamil',
      'hi': '',
    },
    'xpe0krvk': {
      'en': 'Bengali',
      'hi': '',
    },
    'lpqg138l': {
      'en': 'Gujrati',
      'hi': '',
    },
    'd0xzfyaq': {
      'en': 'Malyalam',
      'hi': '',
    },
    '4t9fnxwu': {
      'en': 'Urdu',
      'hi': '',
    },
    'h3neusm3': {
      'en': 'Oriya',
      'hi': '',
    },
    '7iozuh5v': {
      'en': 'Other',
      'hi': '',
    },
    'iq1e3392': {
      'en': 'Kannada',
      'hi': '',
    },
    'dofn1jah': {
      'en': 'Punjabi',
      'hi': '',
    },
    'jwsfbvt8': {
      'en': 'Assamese',
      'hi': '',
    },
    'xg0y0hd5': {
      'en': 'Maithili',
      'hi': '',
    },
    'p13f7d4k': {
      'en': 'Konkani',
      'hi': '',
    },
    'hev3gusk': {
      'en': 'Sindhi',
      'hi': '',
    },
    '34pisfh0': {
      'en': 'Hindi',
      'hi': '',
    },
    'le8qrwzf': {
      'en': 'Hindi',
      'hi': '',
    },
    'gvtv5j40': {
      'en': 'English',
      'hi': '',
    },
    'pbudcad7': {
      'en': 'Religion',
      'hi': '',
    },
    'qjadxcuh': {
      'en': 'Hindu',
      'hi': '',
    },
    '1rgntlcd': {
      'en': 'Spiritual',
      'hi': '',
    },
    'siui533i': {
      'en': 'Muslim',
      'hi': '',
    },
    'eckj7n6a': {
      'en': 'Christian',
      'hi': '',
    },
    '6v4hfvqt': {
      'en': 'Atheist',
      'hi': '',
    },
    '0sxvmzss': {
      'en': 'Agnostic',
      'hi': '',
    },
    'apwlq8fd': {
      'en': 'Buddhist',
      'hi': '',
    },
    'bp02fecl': {
      'en': 'Jewish',
      'hi': '',
    },
    '97vx4uxt': {
      'en': 'Parsi',
      'hi': '',
    },
    '399v2ap2': {
      'en': 'Sikh',
      'hi': '',
    },
    '6yc30ljr': {
      'en': 'Jain',
      'hi': '',
    },
    'w93l9wq5': {
      'en': 'Other',
      'hi': '',
    },
    'yu8uqvoa': {
      'en': 'Hindu',
      'hi': '',
    },
    'cnknh0na': {
      'en': 'Do they exercise',
      'hi': '',
    },
    'pkl6uipa': {
      'en': 'sometimes',
      'hi': '',
    },
    'qiu6o6c9': {
      'en': 'regularly',
      'hi': '',
    },
    'gepsi16m': {
      'en': 'sometimes',
      'hi': '',
    },
    '4z75jdk6': {
      'en': 'not active',
      'hi': '',
    },
    'xu75xzil': {
      'en': 'Do they drink',
      'hi': '',
    },
    'sumarza5': {
      'en': 'Never',
      'hi': '',
    },
    'qwbunvb4': {
      'en': 'Occasionaly',
      'hi': '',
    },
    'n2z7semu': {
      'en': 'Regular',
      'hi': '',
    },
    '3rgvr8x3': {
      'en': 'Never',
      'hi': '',
    },
    'vj08bfw3': {
      'en': 'Do they smoke',
      'hi': '',
    },
    'vlipi10p': {
      'en': 'Never',
      'hi': '',
    },
    'zs4jxv2k': {
      'en': 'Occasionaly',
      'hi': '',
    },
    '9ohgvu44': {
      'en': 'Regular',
      'hi': '',
    },
    '4qpu8l05': {
      'en': 'Never',
      'hi': '',
    },
    'ifbfrabt': {
      'en': 'Trying to Quit',
      'hi': '',
    },
    '8ufslx5p': {
      'en': 'Looking for ',
      'hi': '',
    },
    'q0320ct6': {
      'en': 'relationship',
      'hi': '',
    },
    'oww0azyz': {
      'en': 'relationship',
      'hi': '',
    },
    'o249yuq2': {
      'en': 'casual',
      'hi': '',
    },
    'nep2ffjk': {
      'en': 'dont know yet',
      'hi': '',
    },
    '0lj0flqu': {
      'en': 'Political Leanings',
      'hi': '',
    },
    '9227xmkh': {
      'en': 'Apolitical',
      'hi': '',
    },
    'kki00q85': {
      'en': 'Liberal',
      'hi': '',
    },
    'vko69w6a': {
      'en': 'Conservative',
      'hi': '',
    },
    '2o8jrjaf': {
      'en': 'Socialist',
      'hi': '',
    },
    'rcsuxp3f': {
      'en': 'Apolitical',
      'hi': '',
    },
    'yw28uk6f': {
      'en': 'Libertarian',
      'hi': '',
    },
    '4vr73j0s': {
      'en': 'Moderate',
      'hi': '',
    },
    'kj1iijnc': {
      'en': 'Zodiac sign',
      'hi': '',
    },
    'jo8id1u3': {
      'en': 'Aries',
      'hi': '',
    },
    '1d7gwfra': {
      'en': 'Taurus',
      'hi': '',
    },
    'k5vacc96': {
      'en': 'Gemini',
      'hi': '',
    },
    'yxaazzub': {
      'en': 'Cancer',
      'hi': '',
    },
    '3p1d2yz1': {
      'en': 'Leo',
      'hi': '',
    },
    '8h7mr0lp': {
      'en': 'Virgo',
      'hi': '',
    },
    '6he9bo19': {
      'en': 'Libra',
      'hi': '',
    },
    'hx5t9cyz': {
      'en': 'Scorpio',
      'hi': '',
    },
    '2geofnxb': {
      'en': 'Sagittarius',
      'hi': '',
    },
    '85d5zop9': {
      'en': 'Capricorn',
      'hi': '',
    },
    'fpifzeyx': {
      'en': 'Aquarius',
      'hi': '',
    },
    'kqtl0ws1': {
      'en': 'Pisces',
      'hi': '',
    },
    'paeje4v4': {
      'en': 'Update preferences',
      'hi': '',
    },
    'vqopjjny': {
      'en': 'Search',
      'hi': '',
    },
  },
  // searchProfileFilters
  {
    '1u53azzs': {
      'en': 'Apply Filters',
      'hi': '',
    },
    'afdtvez3': {
      'en': 'I’m open to date everyone',
      'hi': '',
    },
    'nsbwsoyx': {
      'en': 'Search by',
      'hi': '',
    },
    '7mmsafyk': {
      'en': 'Location',
      'hi': '',
    },
    '31cqwuh6': {
      'en': 'Nearby',
      'hi': '',
    },
    '2357lbdz': {
      'en': 'Nowhere',
      'hi': '',
    },
    'asmw7lhi': {
      'en': 'Preference',
      'hi': '',
    },
    'lzxl1b9s': {
      'en': 'Age',
      'hi': '',
    },
    'zznyu7bx': {
      'en': 'Between 18 to 28',
      'hi': '',
    },
    'h9hr6s6w': {
      'en': 'See people 2 years either side if I \nrun out',
      'hi': '',
    },
    'x51o6ab0': {
      'en': 'Distance',
      'hi': '',
    },
    'btfiq4vk': {
      'en': 'Up to 46 kilometer away',
      'hi': '',
    },
    'z9g6ehm8': {
      'en': 'See people slightly further away if I \nrun out',
      'hi': '',
    },
    'u58gad1v': {
      'en': 'By religion',
      'hi': '',
    },
    'qcn70xi2': {
      'en': 'Hindu',
      'hi': '',
    },
    'zs0hwq8d': {
      'en': 'Spotlight',
      'hi': '',
    },
    'ufhxp0io': {
      'en': 'from \$50.90...',
      'hi': '',
    },
    'tejtvd49': {
      'en': 'Boost',
      'hi': '',
    },
    'd9u3em16': {
      'en': 'from \$29.90...',
      'hi': '',
    },
    'rdvbl4fp': {
      'en': 'Apply',
      'hi': '',
    },
    'b11n0yaq': {
      'en': 'Home',
      'hi': '',
    },
  },
  // connectionandgroups
  {
    'x7sf8t6u': {
      'en': 'You can only connect with Subscription',
      'hi': '',
    },
    'd1u9knux': {
      'en': 'Subscribe Now',
      'hi': '',
    },
    'w32xgh2x': {
      'en': 'Your connections',
      'hi': '',
    },
    '286yq7pb': {
      'en': 'Start Chat',
      'hi': '',
    },
    'vy382n3d': {
      'en': 'Requests',
      'hi': '',
    },
    '9wnd6mkr': {
      'en': 'Accept',
      'hi': '',
    },
    '4n4inlob': {
      'en': 'Your groups',
      'hi': '',
    },
    'q6ayvyd6': {
      'en': 'Go to group chat',
      'hi': '',
    },
    '6bkuoh23': {
      'en': 'Faceout',
      'hi': '',
    },
    'rs2y1e7v': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Social
  {
    'fee7k54t': {
      'en': '',
      'hi': '',
    },
    'fjcit96n': {
      'en': 'Search for events',
      'hi': '',
    },
    'lwnu8byl': {
      'en': 'Events',
      'hi': '',
    },
    'u50pahly': {
      'en': 'Sports',
      'hi': '',
    },
    'dc7rm7cl': {
      'en': 'Extreme',
      'hi': '',
    },
    'yrbxyxg8': {
      'en': 'Social',
      'hi': '',
    },
    'uxj6zz2g': {
      'en': 'Popular Events',
      'hi': '',
    },
    '5l1bjp2i': {
      'en': 'See more',
      'hi': '',
    },
    'efzkp0em': {
      'en': 'Parties',
      'hi': '',
    },
    '36gdtbqd': {
      'en': 'Food',
      'hi': '',
    },
    'pi32m4t6': {
      'en': 'Music',
      'hi': '',
    },
    'hrsuraf5': {
      'en': 'Comedy',
      'hi': '',
    },
    'hug6hnu2': {
      'en': 'Concert',
      'hi': '',
    },
    'rdvs65p5': {
      'en': 'IN THE LIMELIGHT',
      'hi': '',
    },
    'mw3olvkg': {
      'en': 'Events',
      'hi': '',
    },
    'sns66r82': {
      'en': 'Sports',
      'hi': '',
    },
    'wci9b1xj': {
      'en': 'Extreme',
      'hi': '',
    },
    '5ikhhavl': {
      'en': 'Social',
      'hi': '',
    },
    'bpnj635s': {
      'en': 'SPORTS NEAR YOU',
      'hi': '',
    },
    '6fb46l2m': {
      'en': 'Events',
      'hi': '',
    },
    'hy8a2qgo': {
      'en': 'Sports',
      'hi': '',
    },
    'hqo1c9p4': {
      'en': 'Extreme',
      'hi': '',
    },
    '7t9m3b2h': {
      'en': 'Social',
      'hi': '',
    },
    '0ts9ts02': {
      'en': 'ADVENTURES YOU WILL LOVE',
      'hi': '',
    },
    'whqckzyo': {
      'en': 'Events',
      'hi': '',
    },
    'ubbqzjbe': {
      'en': 'Sports',
      'hi': '',
    },
    'bsy7y6yj': {
      'en': 'Extreme',
      'hi': '',
    },
    '51p06heg': {
      'en': 'Social',
      'hi': '',
    },
    '58klezl6': {
      'en': 'CREATING EXPIRIENCES',
      'hi': '',
    },
    'k4efnane': {
      'en': 'Book a slot',
      'hi': '',
    },
    'zwi2zu3b': {
      'en': 'Monthly pass at ₹599',
      'hi': '',
    },
    'oyjk1v31': {
      'en': 'Apply Filters',
      'hi': '',
    },
    'jzivarxo': {
      'en':
          'To change the category type, switch from the tab bar and then use filter.',
      'hi': '',
    },
    'vfy9wtq3': {
      'en': 'Premium',
      'hi': '',
    },
    '881hjyih': {
      'en': 'Show only premium groups',
      'hi': '',
    },
    'lhai7bgm': {
      'en': 'Show all groups',
      'hi': '',
    },
    'ocaw3d7r': {
      'en': 'Only nearby groups will be shown.',
      'hi': '',
    },
    'ecz0us4x': {
      'en': 'Choose Interests',
      'hi': '',
    },
    'qnpx5r6y': {
      'en': 'Self Care',
      'hi': '',
    },
    '3by7jw31': {
      'en': 'Running',
      'hi': '',
    },
    'mgfk6nn0': {
      'en': 'Gym',
      'hi': '',
    },
    'lzl456yc': {
      'en': 'Physical fitness',
      'hi': '',
    },
    'v8xnjp8l': {
      'en': 'Hygiene',
      'hi': '',
    },
    '2i92kbr9': {
      'en': 'Muscle relaxation',
      'hi': '',
    },
    'u3fcc1uh': {
      'en': 'Meditation',
      'hi': '',
    },
    '0vsm9cqw': {
      'en': 'Healthy cooking',
      'hi': '',
    },
    'sbxf2rl9': {
      'en': 'Yoga',
      'hi': '',
    },
    'hpumcnup': {
      'en': 'Reading ',
      'hi': '',
    },
    'kqs7bb40': {
      'en': 'Sports',
      'hi': '',
    },
    'bwjg9ali': {
      'en': 'Basketball',
      'hi': '',
    },
    '8cshkpxe': {
      'en': 'Cricket',
      'hi': '',
    },
    'oixo7n7d': {
      'en': 'Soccer',
      'hi': '',
    },
    '1rj16vd0': {
      'en': 'Tennis',
      'hi': '',
    },
    'dor8zd8d': {
      'en': 'Swimming',
      'hi': '',
    },
    'dlb63dm7': {
      'en': 'Volleyball',
      'hi': '',
    },
    '3u2g3gfj': {
      'en': 'Cycling',
      'hi': '',
    },
    'l2jxku7w': {
      'en': 'Golf',
      'hi': '',
    },
    'ug4hbh9j': {
      'en': 'Baseball',
      'hi': '',
    },
    'a9arn2lc': {
      'en': 'Music',
      'hi': '',
    },
    'wm2yrpyu': {
      'en': 'Rock',
      'hi': '',
    },
    'a3qbmibq': {
      'en': 'Jazz',
      'hi': '',
    },
    'nj96hlre': {
      'en': 'Soft',
      'hi': '',
    },
    'vlc9lp7a': {
      'en': 'Lo-fi',
      'hi': '',
    },
    '9c4dpdeh': {
      'en': 'English',
      'hi': '',
    },
    'uoqbld22': {
      'en': 'Hindi',
      'hi': '',
    },
    'w1m9elyh': {
      'en': 'Playing an instrument',
      'hi': '',
    },
    'kgjhwhrn': {
      'en': 'Singing',
      'hi': '',
    },
    '7nea5zxi': {
      'en': 'Hip-hop',
      'hi': '',
    },
    'np3111kv': {
      'en': 'Electronic music',
      'hi': '',
    },
    'arempv94': {
      'en': 'Pop music',
      'hi': '',
    },
    'mesg99xj': {
      'en': 'Folk music',
      'hi': '',
    },
    'i6nxtrdh': {
      'en': 'Art and Creativity',
      'hi': '',
    },
    'lu35sg4d': {
      'en': 'Paint',
      'hi': '',
    },
    'hlfghrbh': {
      'en': 'Photography',
      'hi': '',
    },
    '7y799dxc': {
      'en': 'Videography',
      'hi': '',
    },
    '4lzzjc39': {
      'en': 'Abstact',
      'hi': '',
    },
    'gcj9lam9': {
      'en': 'Therater',
      'hi': '',
    },
    '0gbo35ok': {
      'en': 'Drawing and sketching',
      'hi': '',
    },
    'yu1u3qa7': {
      'en': 'Graphic design',
      'hi': '',
    },
    'dt7ejlt6': {
      'en': 'Creative writing',
      'hi': '',
    },
    '69x8nu3i': {
      'en': 'Pottery',
      'hi': '',
    },
    '0apzfixk': {
      'en': 'DIY crafts\n',
      'hi': '',
    },
    'mx4jusya': {
      'en': 'Pets',
      'hi': '',
    },
    '77kq023h': {
      'en': 'Dog',
      'hi': '',
    },
    '67che7w7': {
      'en': 'Cat',
      'hi': '',
    },
    'opv0cb4l': {
      'en': 'Bird',
      'hi': '',
    },
    'j9bubapd': {
      'en': 'Fish',
      'hi': '',
    },
    'ddvgl1go': {
      'en': 'Pet grooming',
      'hi': '',
    },
    '6fc6b91v': {
      'en': 'Exotic pets',
      'hi': '',
    },
    'm1lebku8': {
      'en': 'Horseback riding',
      'hi': '',
    },
    'gv9op87g': {
      'en': 'Outdoor Activities',
      'hi': '',
    },
    '3kje1v2e': {
      'en': 'Hiking',
      'hi': '',
    },
    'wkdesgvz': {
      'en': 'Biking',
      'hi': '',
    },
    'gkbqfdat': {
      'en': 'Traveling',
      'hi': '',
    },
    'uujhhnqx': {
      'en': 'Explorer',
      'hi': '',
    },
    'tl0y54lg': {
      'en': 'Camping',
      'hi': '',
    },
    'klplsare': {
      'en': 'Stargazing',
      'hi': '',
    },
    'n1eu1abf': {
      'en': 'Fishing',
      'hi': '',
    },
    'akt541re': {
      'en': 'Rock climbing',
      'hi': '',
    },
    '0383rgt1': {
      'en': 'Gardening',
      'hi': '',
    },
    'y7ev04u7': {
      'en': 'Spirituality and Mindfulness',
      'hi': '',
    },
    '4tecrk95': {
      'en': 'Meditation',
      'hi': '',
    },
    'tevcgasi': {
      'en': 'Yoga',
      'hi': '',
    },
    'zbcu76ei': {
      'en': 'Spiritual communities',
      'hi': '',
    },
    'xebsnxpe': {
      'en': 'Prayer',
      'hi': '',
    },
    'n9x4o841': {
      'en': 'Retreats',
      'hi': '',
    },
    '97ndq2cq': {
      'en': 'Astrology',
      'hi': '',
    },
    'eqfl3vmr': {
      'en': 'Tarot reading',
      'hi': '',
    },
    'z5ynnuxx': {
      'en': 'Apply Filters',
      'hi': '',
    },
    '8gsyl0dz': {
      'en': 'Fun Circle',
      'hi': '',
    },
  },
  // viewGroup
  {
    '7viny6sh': {
      'en': 'Go to group chat',
      'hi': '',
    },
    '8mstetzh': {
      'en': 'Art',
      'hi': '',
    },
    'mtjucl9n': {
      'en': 'Museums & galleries',
      'hi': '',
    },
    '6e65792l': {
      'en': 'Coffee',
      'hi': '',
    },
    'ogn45apx': {
      'en': 'Cat',
      'hi': '',
    },
    'sv0vgi7n': {
      'en': 'Movie',
      'hi': '',
    },
    '3cbmvxxx': {
      'en': 'Dog',
      'hi': '',
    },
    '0524u5ha': {
      'en': 'Travel',
      'hi': '',
    },
    'g3y016dz': {
      'en': 'About',
      'hi': '',
    },
    '6c0kr7oz': {
      'en': 'Images',
      'hi': '',
    },
    'jovc4mkg': {
      'en': 'Terms and Conditions',
      'hi': '',
    },
    'i1rhncla': {
      'en':
          'Participation is at your own risk. Fun Circle is a platform that connects people for meetups but does not take responsibility for injuries or disputes during events.\n\nRefunds & Cancellations: Refunds are subject to the event organizer’s policy. No-shows may not receive refunds.\n\nRespect & Sportsmanship: All participants must maintain respect and fair play. Any form of misconduct, aggression, or violation of group rules may result in removal from the event.\n\nEvent Changes: Organizers have the right to modify or cancel events due to unforeseen circumstances. Participants will be notified in such cases.\n\nLiability Waiver: By joining a meetup, you acknowledge that Fun Circle and event organizers are not liable for any injuries, damages, or lost items during the event.\n\nPhotography & Media: Photos/videos may be taken during events for promotional purposes. If you don’t wish to be photographed, inform the organizer beforehand.\n\nCompliance with Venue Rules: Participants must follow all rules set by the venue or sports facility.\n\nBy joining a meetup, you agree to these terms. Enjoy the game! 🎉',
      'hi': '',
    },
    '0pf0hrn9': {
      'en': 'FAQs',
      'hi': '',
    },
    '6hfvih2b': {
      'en':
          '1. How do I join a sports meetup?\nSimply tap on a sports event you’re interested in and confirm your spot. Some events may have limited slots, so book early!\n\n2. Is there a fee to join the meetup?\nYes, most meetups have a small participation fee that covers venue booking, equipment, and organizing costs. The fee varies per event.\n\n3. What happens if I can’t attend after booking?\nIf you cancel at least 24 hours before the event, you may be eligible for a refund or rescheduling (subject to organizer policy). Last-minute cancellations may not be refunded.\n\n4. Do I need to bring my own equipment?\nIt depends on the event. Some sports meetups provide equipment, while others require you to bring your own. Check the event details for specific requirements.\n\n5. What if the event gets canceled?\nIf an event is canceled by the organizer due to weather, venue issues, or other reasons, you’ll receive a refund or the option to join a rescheduled event.\n\n6. Can I bring friends?\nYes! If there are available slots, you can invite friends to join. They must register through the app before attending.\n\n7. Are the events beginner-friendly?\nMost events welcome players of all skill levels. Some advanced sessions may be specified as “Experienced Only.”\n\n8. Who do I contact for help?\nFor any issues, reach out to the event organizer via the chat option in the app.',
      'hi': '',
    },
    '2bres7fk': {
      'en': 'From Rs. 149 onwards',
      'hi': '',
    },
    'wfo1h0kg': {
      'en': 'Book slots',
      'hi': '',
    },
    '2gc12uyo': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Recommended
  {
    'ru4feg7j': {
      'en': 'Recommended',
      'hi': '',
    },
    'ri6n11si': {
      'en': 'We recommend you to \ncomplete profile',
      'hi': '',
    },
    'wvwejo9v': {
      'en': 'Complete Profile',
      'hi': '',
    },
    'obmvwh1u': {
      'en': '7 Tailored profiles',
      'hi': '',
    },
    '8ksekgtm': {
      'en': 'Get 7 recommendations, 7X Faster',
      'hi': '',
    },
    'u8l9zjei': {
      'en': 'Get premium',
      'hi': '',
    },
    'xr78ogax': {
      'en':
          'Prioritizing quality matches, and eliminating choice overload. Skip the waiting game,\n start connecting!',
      'hi': '',
    },
    'ziumtlvw': {
      'en': 'New recommendations loaded ',
      'hi': '',
    },
    'oztm6wmq': {
      'en': 'Start',
      'hi': '',
    },
    '02h8uzdm': {
      'en': 'New Recommendations in ',
      'hi': '',
    },
    '7g4188p3': {
      'en': 'Amazing recommendations are waiting for you ',
      'hi': '',
    },
    'cvwbv498': {
      'en': 'Start Recommending',
      'hi': '',
    },
    '61tosgli': {
      'en': 'Chat',
      'hi': '',
    },
    'e52arcaa': {
      'en': 'Match',
      'hi': '',
    },
  },
  // Premium
  {
    'u1pgkujx': {
      'en': '1 Month',
      'hi': '',
    },
    '0k7xua2n': {
      'en': '1 Month',
      'hi': '',
    },
    '7p1l0n2x': {
      'en': 'PRO',
      'hi': '',
    },
    '9d081fto': {
      'en': 'month',
      'hi': '',
    },
    '5jh8i8jg': {
      'en': 'ELITE',
      'hi': '',
    },
    'zqnwclkj': {
      'en': 'month',
      'hi': '',
    },
    'k3q6jzb6': {
      'en': 'CURRENT SPORTS',
      'hi': '',
    },
    'bu11yel7': {
      'en': 'Badminton',
      'hi': '',
    },
    'ji8za6lf': {
      'en': 'PRO BENEFITS',
      'hi': '',
    },
    'd3t0qzi7': {
      'en': 'Currently only badminton is live',
      'hi': '',
    },
    'crt8stbk': {
      'en': 'Top',
      'hi': '',
    },
    'squjrkfm': {
      'en':
          'Currently only badminton is available to book on our app, Once other games are available, you can use this on those entries too.',
      'hi': '',
    },
    'jlkswgxd': {
      'en': '8 entries per month',
      'hi': '',
    },
    'esect2d2': {
      'en': 'Top',
      'hi': '',
    },
    '323qkgmr': {
      'en': 'Unlock up to 8 slots (morning, evening) ',
      'hi': '',
    },
    'zqhbvy9h': {
      'en': '2 entries can be used by your friends',
      'hi': '',
    },
    'qe6t5xg5': {
      'en': 'Out of those 8 entries, 2 can be used by your friends',
      'hi': '',
    },
    'tieon7pr': {
      'en': 'This will work on evening slots too',
      'hi': '',
    },
    '04gev743': {
      'en':
          'Even though we charge more for evening slots, you can access this pass on evening slots too.',
      'hi': '',
    },
    '570495oz': {
      'en': 'Pre-book',
      'hi': '',
    },
    'eroneiyr': {
      'en': 'Access pre booking option on the app(1 day before normal people)',
      'hi': '',
    },
    'spssvfks': {
      'en': '4 slots will be used in tournaments',
      'hi': '',
    },
    '0b0t5epg': {
      'en':
          'If you buy a membership before a tournament, please know that 4 slots will be used.',
      'hi': '',
    },
    'uoncleck': {
      'en': 'ELITE BENEFITS',
      'hi': '',
    },
    'ugefdmpr': {
      'en': 'Currently only Box cricket is live',
      'hi': '',
    },
    '7wrnrj8p': {
      'en': 'Top',
      'hi': '',
    },
    'niirbh0w': {
      'en':
          'Currently only Box cricket is available to book on our app, Once other games are available, you can use this on those entries too.',
      'hi': '',
    },
    'fmr3zagi': {
      'en': '8 entries per month',
      'hi': '',
    },
    'i2xbt3uf': {
      'en': 'Unlock up to 8 slots (morning, evening) ',
      'hi': '',
    },
    'd26rjbu1': {
      'en': 'You can create groups',
      'hi': '',
    },
    'kyuriq21': {
      'en': 'Top',
      'hi': '',
    },
    'sjlqzmaz': {
      'en': 'Premium members can create groups for their specific interests',
      'hi': '',
    },
    '0c4iyg49': {
      'en': 'This will work on evening slots too',
      'hi': '',
    },
    '4qubirbo': {
      'en':
          'Even though we charge more for evening slots, you can access this pass on evening slots too.',
      'hi': '',
    },
    '8jw6nq7k': {
      'en': 'Pre-book',
      'hi': '',
    },
    '57ddvobm': {
      'en': 'Access pre booking option on the app(1 day before normal people)',
      'hi': '',
    },
    '1sejvy5n': {
      'en': 'SUBSCRIPTION',
      'hi': '',
    },
    'izpqxq7i': {
      'en': 'payment',
      'hi': '',
    },
  },
  // CreateGroup
  {
    '2kyuvel5': {
      'en': 'Create group',
      'hi': '',
    },
    '2h3yqbxn': {
      'en': 'Enter group name',
      'hi': '',
    },
    'skahpv4s': {
      'en': 'Select Location',
      'hi': '',
    },
    'oa24hwck': {
      'en': 'Group Description',
      'hi': '',
    },
    '2rd2n6nf': {
      'en': 'Outdoor',
      'hi': '',
    },
    'b542h5uo': {
      'en': 'Party',
      'hi': '',
    },
    '7xigupka': {
      'en': 'Search for an item...',
      'hi': '',
    },
    'u7ya344u': {
      'en': 'Party',
      'hi': '',
    },
    'wm9jk4kt': {
      'en': 'Event',
      'hi': '',
    },
    'vqu9mgit': {
      'en': 'Meetup',
      'hi': '',
    },
    '6godapd0': {
      'en': 'Outdoor',
      'hi': '',
    },
    'scsbprjg': {
      'en': 'Select Category',
      'hi': '',
    },
    'dtbfkkoa': {
      'en': 'Music Events',
      'hi': '',
    },
    'anosmdaz': {
      'en': 'Fitness',
      'hi': '',
    },
    'umkvnf77': {
      'en': 'Search for an item...',
      'hi': '',
    },
    'pl6jl33p': {
      'en': 'Cultural',
      'hi': '',
    },
    '8ffeuq5z': {
      'en': 'Charity',
      'hi': '',
    },
    'pumu8hch': {
      'en': 'Education',
      'hi': '',
    },
    'zonp76ss': {
      'en': 'Workshops',
      'hi': '',
    },
    'g40kje0q': {
      'en': 'Music Events',
      'hi': '',
    },
    'qrpcflaz': {
      'en': 'Comedy Events',
      'hi': '',
    },
    'qsy3xlat': {
      'en': 'Visual Arts',
      'hi': '',
    },
    '2b9o2fce': {
      'en': 'Religion and Sprituality',
      'hi': '',
    },
    'xkc001k7': {
      'en': 'Festival & Fair',
      'hi': '',
    },
    'nfih1fbg': {
      'en': 'Home Concerts',
      'hi': '',
    },
    'acynjx0b': {
      'en': 'Poetry Events',
      'hi': '',
    },
    'z63oabcn': {
      'en': 'Award Show ',
      'hi': '',
    },
    '7cv8hy9h': {
      'en': 'Conference',
      'hi': '',
    },
    'miw03jou': {
      'en': 'New year 2024',
      'hi': '',
    },
    'ho2t0m1i': {
      'en': 'Movie Screening ',
      'hi': '',
    },
    '7jc49pqz': {
      'en': 'Sports',
      'hi': '',
    },
    '7w5ehdwg': {
      'en': 'Explore',
      'hi': '',
    },
    'jge6gncf': {
      'en': 'Foodies',
      'hi': '',
    },
    'kz8sm21n': {
      'en': 'Buddies',
      'hi': '',
    },
    'ta5gw0vp': {
      'en': 'Books& Literature',
      'hi': '',
    },
    '11gtjl8t': {
      'en': 'Art and Craft',
      'hi': '',
    },
    'i3bsujck': {
      'en': 'Gaming',
      'hi': '',
    },
    '9bnrn7qo': {
      'en': 'Pets',
      'hi': '',
    },
    '7vjcs5a8': {
      'en': 'Coding and Tech',
      'hi': '',
    },
    '2fbrkaq6': {
      'en': 'Fitness',
      'hi': '',
    },
    'rojjqap5': {
      'en': 'Volunteering',
      'hi': '',
    },
    'zywsc51r': {
      'en': 'Hiking',
      'hi': '',
    },
    '91txz3do': {
      'en': 'Trips',
      'hi': '',
    },
    '5zq1nol9': {
      'en': 'Add Images',
      'hi': '',
    },
    'tissf6qo': {
      'en': 'Cover Pic',
      'hi': '',
    },
    't4lgftab': {
      'en': 'Set as Primary',
      'hi': '',
    },
    'cwfoghqc': {
      'en': 'Set as Primary',
      'hi': '',
    },
    'xjlbeu5h': {
      'en': 'Set as Primary',
      'hi': '',
    },
    'yrt1c1qy': {
      'en': 'Set as Primary',
      'hi': '',
    },
    'npb3r8vy': {
      'en': 'Interests',
      'hi': '',
    },
    '4t96rbic': {
      'en': 'Running',
      'hi': '',
    },
    '899pleuz': {
      'en': 'gym',
      'hi': '',
    },
    'ciwe6zb1': {
      'en': 'Physical ',
      'hi': '',
    },
    'b0l2m0pf': {
      'en': 'Hygiene',
      'hi': '',
    },
    'shixgp4c': {
      'en': 'Muscle relaxation',
      'hi': '',
    },
    'is8uod3h': {
      'en': 'Field is required',
      'hi': '',
    },
    '9e5xx10w': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    '77r8m0t4': {
      'en': 'Field is required',
      'hi': '',
    },
    'wktjvkt1': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'mjvmqbqp': {
      'en': 'Create Group Ticket',
      'hi': '',
    },
    '4zwoid1l': {
      'en': 'Create Group',
      'hi': '',
    },
    '4v8tu7lh': {
      'en': 'Home',
      'hi': '',
    },
  },
  // CompleteProfilePage
  {
    '903fkmr9': {
      'en': 'We have all your\n basic details',
      'hi': '',
    },
    'xogd82mr': {
      'en': 'You are half done',
      'hi': '',
    },
    'bx4ir1ob': {
      'en': 'We can recommend better if you take\ntime to complete profile. ',
      'hi': '',
    },
    'qwk4hrks': {
      'en': 'Complete Profile',
      'hi': '',
    },
    '42bmqzuh': {
      'en': 'No, I will complete later',
      'hi': '',
    },
    'ob4e26os': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Name
  {
    'n02z83lt': {
      'en': '18%',
      'hi': '',
    },
    'pguz45og': {
      'en': 'Introduce yourself',
      'hi': '',
    },
    'o9admbqb': {
      'en': 'First Name',
      'hi': '',
    },
    'y08w4o5j': {
      'en': 'Retry Location',
      'hi': '',
    },
    'jzs3wigr': {
      'en': 'Select City ',
      'hi': '',
    },
    '7pcdy73a': {
      'en': 'Email',
      'hi': '',
    },
    'a8wvzyll': {
      'en': 'Field is required',
      'hi': '',
    },
    'i1h0aut0': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'hgfp6vl8': {
      'en': 'Field is required',
      'hi': '',
    },
    'xoax1lh8': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'a6i8vb9p': {
      'en': 'Male',
      'hi': '',
    },
    'ucjchy8e': {
      'en': 'Female',
      'hi': '',
    },
    '4cgzp0tf': {
      'en': 'Home',
      'hi': '',
    },
  },
  // SignupNew
  {
    'fm1s2e2t': {
      'en': 'Signup',
      'hi': '',
    },
    '4pvnp529': {
      'en': 'Your Information',
      'hi': '',
    },
    '1537jv10': {
      'en': 'Fill in your details below to continue',
      'hi': '',
    },
    'aai2gf2y': {
      'en': 'Name',
      'hi': '',
    },
    'wv5hj1lv': {
      'en': 'Rishabh',
      'hi': '',
    },
    '7u41wy1p': {
      'en': 'Email',
      'hi': '',
    },
    'mdmelj18': {
      'en': 'robert@gmail.com',
      'hi': '',
    },
    'lpcyrhip': {
      'en': 'Mobile Number',
      'hi': '',
    },
    '981c6ey7': {
      'en': '9999999999',
      'hi': '',
    },
    '33ba2uw5': {
      'en': 'Name is required',
      'hi': '',
    },
    'jsej97x4': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    '7ketliqc': {
      'en': 'Email is required',
      'hi': '',
    },
    'eldrrsfa': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'teouyvt3': {
      'en': 'Mobile Number is required',
      'hi': '',
    },
    '0jjp9y7r': {
      'en': 'Enter complete mobile number',
      'hi': '',
    },
    'hqaloq9a': {
      'en': 'Enter correct mobile number',
      'hi': '',
    },
    '6rep7xrk': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'y65yck2f': {
      'en': 'Complete Profile',
      'hi': '',
    },
    'ti1zdkym': {
      'en': 'Home',
      'hi': '',
    },
  },
  // OtpVerification
  {
    'vz0u5omb': {
      'en': 'Verify your number',
      'hi': '',
    },
    '9ns36e4b': {
      'en': 'Enter the code that we’ve send to +91 ',
      'hi': '',
    },
    'c7cinszg': {
      'en': ' Change',
      'hi': '',
    },
    's9n7isrd': {
      'en': 'PIN code is required',
      'hi': '',
    },
    'fo6bk954': {
      'en': 'Resend OTP',
      'hi': '',
    },
    'xp2hwog5': {
      'en': 'Submit',
      'hi': '',
    },
    'vc2votd4': {
      'en': 'Home',
      'hi': '',
    },
  },
  // AddImages
  {
    'ma6xi67i': {
      'en': '24%',
      'hi': '',
    },
    '75ulwsjx': {
      'en': 'Add 2+ images for increased visibility',
      'hi': '',
    },
    '2w0ip7q9': {
      'en': 'Add your best images',
      'hi': '',
    },
    'jqg74eun': {
      'en': '2  required',
      'hi': '',
    },
    '6cljojzj': {
      'en': 'Main',
      'hi': '',
    },
    'srdhtu7z': {
      'en': 'Set as Main',
      'hi': '',
    },
    'e4nnt2oz': {
      'en': 'Set as Main',
      'hi': '',
    },
    'z2frd8y1': {
      'en': 'Set as Main',
      'hi': '',
    },
    'zahqfbsq': {
      'en': 'Set as Main',
      'hi': '',
    },
    'krv4kghn': {
      'en': 'For more results do this',
      'hi': '',
    },
    '6ejfanek': {
      'en': 'Upload atleast 2 images',
      'hi': '',
    },
    'yy2k3x8x': {
      'en': 'Smile please',
      'hi': '',
    },
    'buejbo4j': {
      'en': 'No inappropriate content',
      'hi': '',
    },
    'lplct64b': {
      'en': 'Real images of yourself',
      'hi': '',
    },
    'yhtdyqqx': {
      'en': 'Well-lit, Bright photo',
      'hi': '',
    },
    '2e4s0o0p': {
      'en': 'Group photo',
      'hi': '',
    },
    'e47xyq9m': {
      'en': 'image',
      'hi': '',
    },
  },
  // Drink
  {
    'skx30t0f': {
      'en': '56%',
      'hi': '',
    },
    'vaxf3430': {
      'en': 'Do you drink ?',
      'hi': '',
    },
    'j39rbjq3': {
      'en': 'Ocassionaly',
      'hi': '',
    },
    'msr1i7gc': {
      'en': 'Regular',
      'hi': '',
    },
    'udsjyqgk': {
      'en': 'Never',
      'hi': '',
    },
    'xpq221mk': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Workandeducation
  {
    'egsbbwvj': {
      'en': '95%',
      'hi': '',
    },
    'w1cnc734': {
      'en': 'Works &\nEducation',
      'hi': '',
    },
    'h6dxgi3l': {
      'en': 'College',
      'hi': '',
    },
    'o6m49f1o': {
      'en': 'Graduation Year',
      'hi': '',
    },
    '3o68xc48': {
      'en': 'Work title',
      'hi': '',
    },
    '58ybsoqw': {
      'en': 'Company or Industry',
      'hi': '',
    },
    'cknxnznx': {
      'en': 'Field is required',
      'hi': '',
    },
    '378ggyhs': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'ujx9am47': {
      'en': 'Field is required',
      'hi': '',
    },
    'b00ya81v': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'm5rpu3k7': {
      'en': 'Field is required',
      'hi': '',
    },
    'yhm0fxvv': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    '7xc55y00': {
      'en': 'Field is required',
      'hi': '',
    },
    'gq12phag': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'zg8b2a0l': {
      'en': 'Home',
      'hi': '',
    },
  },
  // doyousmoke
  {
    '6tdf96e9': {
      'en': '50%',
      'hi': '',
    },
    'f9u9sea4': {
      'en': 'Do you smoke?',
      'hi': '',
    },
    'ffrzti8w': {
      'en': 'Ocassionaly',
      'hi': '',
    },
    'x5f4gfl8': {
      'en': 'Regular',
      'hi': '',
    },
    'b244r15r': {
      'en': 'Never',
      'hi': '',
    },
    'wwaei719': {
      'en': 'Trying to Quit',
      'hi': '',
    },
    '0rw1ykhu': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Religion
  {
    '07yxh01r': {
      'en': '86%',
      'hi': '',
    },
    'cfp1uttq': {
      'en': 'Your faith',
      'hi': '',
    },
    'ugo920mm': {
      'en': 'Hindu',
      'hi': '',
    },
    'v3dumpnx': {
      'en': 'Spiritual',
      'hi': '',
    },
    'rsgmj9ti': {
      'en': 'Muslim',
      'hi': '',
    },
    'hoc5l86q': {
      'en': 'Christian',
      'hi': '',
    },
    'j7qa1fxn': {
      'en': 'Atheist',
      'hi': '',
    },
    '2qzek6ey': {
      'en': 'Agnostic',
      'hi': '',
    },
    'wg0ft2mp': {
      'en': 'Buddhist',
      'hi': '',
    },
    'vki2k5b7': {
      'en': 'Jewish',
      'hi': '',
    },
    'rza5plt9': {
      'en': 'Parsi',
      'hi': '',
    },
    'rqf5sio4': {
      'en': 'Sikh',
      'hi': '',
    },
    'fjhg5u8g': {
      'en': 'Jain',
      'hi': '',
    },
    'lzjsqfuu': {
      'en': 'Other',
      'hi': '',
    },
    'cwapsvho': {
      'en': 'Hindu',
      'hi': '',
    },
    '71pvanzl': {
      'en': 'Home',
      'hi': '',
    },
  },
  // MotherTungue
  {
    'i76d0nxg': {
      'en': '',
      'hi': '',
    },
    'ilug6fi8': {
      'en': 'Your mother tungue',
      'hi': '',
    },
    '4c80mpji': {
      'en': 'Hindi',
      'hi': '',
    },
    'kzwvuwuc': {
      'en': 'English',
      'hi': '',
    },
    'u9e1vvxx': {
      'en': 'Marathi',
      'hi': '',
    },
    'vbvryjc4': {
      'en': 'Telegu',
      'hi': '',
    },
    '49e6tdes': {
      'en': 'Tamil',
      'hi': '',
    },
    'rpafsah4': {
      'en': 'Bengali',
      'hi': '',
    },
    'pjptb199': {
      'en': 'Gujrati',
      'hi': '',
    },
    '93ibrmmm': {
      'en': 'Malyalam',
      'hi': '',
    },
    '3u4oetsm': {
      'en': 'Urdu',
      'hi': '',
    },
    'jnyixfeb': {
      'en': 'Oriya',
      'hi': '',
    },
    'dyxu0pbl': {
      'en': 'Other',
      'hi': '',
    },
    'luuscf5k': {
      'en': 'Kannada',
      'hi': '',
    },
    'ddpi9hxe': {
      'en': 'Punjabi',
      'hi': '',
    },
    'ao9juuas': {
      'en': 'Assamese',
      'hi': '',
    },
    'gxxtsonu': {
      'en': 'Maithili',
      'hi': '',
    },
    'fwyl23pk': {
      'en': 'Konkani',
      'hi': '',
    },
    '2vc5vvgi': {
      'en': 'Sindhi',
      'hi': '',
    },
    't36pxz0d': {
      'en': 'Hindi',
      'hi': '',
    },
    'szcrea84': {
      'en': 'Skip',
      'hi': '',
    },
    '4j3jc6ib': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Lookingfor
  {
    'jpe6m706': {
      'en': '42%',
      'hi': '',
    },
    'o8ue12lv': {
      'en': 'What are you looking for?',
      'hi': '',
    },
    '9oquxnwk': {
      'en': 'Relationship',
      'hi': '',
    },
    'd0umo0dl': {
      'en': 'Casual',
      'hi': '',
    },
    'tujvl17l': {
      'en': 'Don\'t know yet',
      'hi': '',
    },
    'bsb4jvtr': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Hometown
  {
    'hpcautki': {
      'en': 'Location',
      'hi': '',
    },
    'ayyz6eiq': {
      'en': 'Select Location',
      'hi': '',
    },
    '4mg7969c': {
      'en': 'Skip',
      'hi': '',
    },
    'dko7woi0': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Height
  {
    'bmcezlp6': {
      'en': 'What is your height?',
      'hi': '',
    },
    '0yryhq68': {
      'en': 'Skip',
      'hi': '',
    },
    'kac6it0e': {
      'en': 'Home',
      'hi': '',
    },
  },
  // PoliticalLeanings
  {
    'couo08mn': {
      'en': 'Your Political Leanings',
      'hi': '',
    },
    '624erez5': {
      'en': 'Liberal',
      'hi': '',
    },
    'fndgwix5': {
      'en': 'Conservative',
      'hi': '',
    },
    'lvbbju89': {
      'en': 'Socialist',
      'hi': '',
    },
    'qa0e0t1p': {
      'en': 'Libertarian',
      'hi': '',
    },
    '5nz1w8ts': {
      'en': 'Apolitical',
      'hi': '',
    },
    'd5k98dih': {
      'en': 'Moderate',
      'hi': '',
    },
    '9bq6z9y0': {
      'en': 'Skip',
      'hi': '',
    },
    'qpl88ev1': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Workout
  {
    'du40vct0': {
      'en': 'Do you Workout?',
      'hi': '',
    },
    'cn8do40y': {
      'en': 'Active',
      'hi': '',
    },
    'lmycumkb': {
      'en': 'Sometimes',
      'hi': '',
    },
    'regdjf6q': {
      'en': 'Never',
      'hi': '',
    },
    'k3f8gyy4': {
      'en': 'Skip',
      'hi': '',
    },
    'bzc2lf3m': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Zodiac
  {
    '5jz60mt3': {
      'en': 'What is your zodiac?',
      'hi': '',
    },
    '3a5y07gp': {
      'en': 'Aries',
      'hi': '',
    },
    'sromagvr': {
      'en': 'Taurus',
      'hi': '',
    },
    'lzibofe2': {
      'en': 'Gemini',
      'hi': '',
    },
    'no6xi0q3': {
      'en': 'Cancer',
      'hi': '',
    },
    'kvzwdwj1': {
      'en': 'Leo',
      'hi': '',
    },
    'xf2fwsfq': {
      'en': 'Virgo',
      'hi': '',
    },
    'h6rrwpf1': {
      'en': 'Libra',
      'hi': '',
    },
    'rfiwve60': {
      'en': 'Scorpio',
      'hi': '',
    },
    'za5d3mip': {
      'en': 'Sagittarius',
      'hi': '',
    },
    'zk5x3vt3': {
      'en': 'Capricorn',
      'hi': '',
    },
    'l2gr414e': {
      'en': 'Aquarius',
      'hi': '',
    },
    'f5zl3hz1': {
      'en': 'Pisces',
      'hi': '',
    },
    'd9abvi95': {
      'en': 'Skip',
      'hi': '',
    },
    'f8oqdmoj': {
      'en': 'Home',
      'hi': '',
    },
  },
  // bio
  {
    'nitj8dr8': {
      'en': 'Add more about you',
      'hi': '',
    },
    'mkql8g5g': {
      'en':
          'Help potential matched understand more about your presonality by finishing the sentence.',
      'hi': '',
    },
    'r07lx0oa': {
      'en': 'Tell us something about yourself',
      'hi': '',
    },
    'q4e4nh07': {
      'en': 'Field is required',
      'hi': '',
    },
    'direxbof': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'h7a01njs': {
      'en': 'Skip',
      'hi': '',
    },
    'i0c2t4hv': {
      'en': 'Home',
      'hi': '',
    },
  },
  // interests
  {
    '54ywcatu': {
      'en': 'Your Interests',
      'hi': '',
    },
    'sk3km8tg': {
      'en':
          'Pick Up-to 7 things you love. It will help us recommend to more similar people.  \n\nChoose 1 from each category',
      'hi': '',
    },
    'm79gqxm1': {
      'en': 'Self Care',
      'hi': '',
    },
    '8avwwg2d': {
      'en': 'Running',
      'hi': '',
    },
    '19eyaf1o': {
      'en': 'Gym',
      'hi': '',
    },
    '994vqmbw': {
      'en': 'Physical fitness',
      'hi': '',
    },
    'oe8rx67q': {
      'en': 'Hygiene',
      'hi': '',
    },
    'wihdc0mj': {
      'en': 'Muscle relaxation',
      'hi': '',
    },
    'xyrn1a4a': {
      'en': 'Meditation',
      'hi': '',
    },
    'v7vzqp65': {
      'en': 'Healthy cooking',
      'hi': '',
    },
    'w9llnjir': {
      'en': 'Yoga',
      'hi': '',
    },
    'df8kdc51': {
      'en': 'Reading ',
      'hi': '',
    },
    'vgtc91ed': {
      'en': 'Sports',
      'hi': '',
    },
    'foxbzzce': {
      'en': 'Basketball',
      'hi': '',
    },
    '92d52g92': {
      'en': 'Cricket',
      'hi': '',
    },
    '9t3qzxal': {
      'en': 'Soccer',
      'hi': '',
    },
    '9dr8i1cm': {
      'en': 'Tennis',
      'hi': '',
    },
    'axd9rg5t': {
      'en': 'Swimming',
      'hi': '',
    },
    'tefslta8': {
      'en': 'Volleyball',
      'hi': '',
    },
    'shs0jw6u': {
      'en': 'Cycling',
      'hi': '',
    },
    'xtv7lpoq': {
      'en': 'Golf',
      'hi': '',
    },
    'uq58eemp': {
      'en': 'Baseball',
      'hi': '',
    },
    'u1tu90vr': {
      'en': 'Music',
      'hi': '',
    },
    'pn49fotr': {
      'en': 'Rock',
      'hi': '',
    },
    'oupt5mkm': {
      'en': 'Jazz',
      'hi': '',
    },
    'ii6nfhnj': {
      'en': 'Soft',
      'hi': '',
    },
    'q7dnrh5s': {
      'en': 'Lo-fi',
      'hi': '',
    },
    'pp2r2i5u': {
      'en': 'English',
      'hi': '',
    },
    'geuk5x34': {
      'en': 'Hindi',
      'hi': '',
    },
    'x2yopog4': {
      'en': 'Playing an instrument',
      'hi': '',
    },
    '04a0b8tg': {
      'en': 'Singing',
      'hi': '',
    },
    '33o60vyk': {
      'en': 'Hip-hop',
      'hi': '',
    },
    'e24ftu0g': {
      'en': 'Electronic music',
      'hi': '',
    },
    'ermtbtg9': {
      'en': 'Pop music',
      'hi': '',
    },
    '9qgg2mhz': {
      'en': 'Folk music',
      'hi': '',
    },
    '2z5va213': {
      'en': 'Art and Creativity',
      'hi': '',
    },
    'kx2sy4h2': {
      'en': 'Paint',
      'hi': '',
    },
    'syu2qzwk': {
      'en': 'Photography',
      'hi': '',
    },
    'l6h3mlx4': {
      'en': 'Videography',
      'hi': '',
    },
    '3r2ybz42': {
      'en': 'Abstact',
      'hi': '',
    },
    'b8t38bax': {
      'en': 'Therater',
      'hi': '',
    },
    '6gqfnqp3': {
      'en': 'Drawing and sketching',
      'hi': '',
    },
    's5axpcpp': {
      'en': 'Graphic design',
      'hi': '',
    },
    'hx69m0le': {
      'en': 'Creative writing',
      'hi': '',
    },
    'cs88yifk': {
      'en': 'Pottery',
      'hi': '',
    },
    'dtvogw83': {
      'en': 'DIY crafts',
      'hi': '',
    },
    '3lg6zub2': {
      'en': 'Pets',
      'hi': '',
    },
    'a9y3dw49': {
      'en': 'Dog',
      'hi': '',
    },
    '95cnwgxo': {
      'en': 'Cat',
      'hi': '',
    },
    '921yq6uw': {
      'en': 'Bird',
      'hi': '',
    },
    'v9qr6uls': {
      'en': 'Fish',
      'hi': '',
    },
    's07phqwv': {
      'en': 'Pet grooming',
      'hi': '',
    },
    'nd61luuv': {
      'en': 'Exotic pets',
      'hi': '',
    },
    '2ub90jmg': {
      'en': 'Horseback riding',
      'hi': '',
    },
    '3jgdvstx': {
      'en': 'Outdoor Activities',
      'hi': '',
    },
    'ri3yvnks': {
      'en': 'Hiking',
      'hi': '',
    },
    'sd4bb7bv': {
      'en': 'Biking',
      'hi': '',
    },
    '9d1uc2d2': {
      'en': 'Traveling',
      'hi': '',
    },
    '5gzz2dif': {
      'en': 'Explorer',
      'hi': '',
    },
    '93askfg7': {
      'en': 'Camping',
      'hi': '',
    },
    'qd9dcvgq': {
      'en': 'Stargazing',
      'hi': '',
    },
    '42emhj3z': {
      'en': 'Fishing',
      'hi': '',
    },
    'qiq2uhdk': {
      'en': 'Rock climbing',
      'hi': '',
    },
    'oulesggj': {
      'en': 'Gardening',
      'hi': '',
    },
    'y9mocp7p': {
      'en': 'Spirituality and Mindfulness',
      'hi': '',
    },
    'ohhjs3d2': {
      'en': 'Meditation',
      'hi': '',
    },
    'mz1847go': {
      'en': 'Yoga',
      'hi': '',
    },
    'su1uc9k6': {
      'en': 'Spiritual communities',
      'hi': '',
    },
    'jpd3e67d': {
      'en': 'Prayer',
      'hi': '',
    },
    'bx1o2h7r': {
      'en': 'Retreats',
      'hi': '',
    },
    'rp6s21em': {
      'en': 'Astrology',
      'hi': '',
    },
    'uedfczbf': {
      'en': 'Tarot reading',
      'hi': '',
    },
    'fx6ctjzb': {
      'en': 'Skip',
      'hi': '',
    },
    'cs3c7x3r': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Prompts
  {
    '3paysxzr': {
      'en': 'Add Prompts',
      'hi': '',
    },
    'ce5us1zb': {
      'en':
          'Help potential matched understand more about your personality by finishing the sentence.',
      'hi': '',
    },
    'oo9rjejm': {
      'en': 'Skip',
      'hi': '',
    },
    'e2ltqkw5': {
      'en': 'Home',
      'hi': '',
    },
  },
  // answerprompt
  {
    'giq8az2a': {
      'en': 'Prompts',
      'hi': '',
    },
    't9nrd3wt': {
      'en': 'answer here...',
      'hi': '',
    },
    '1zfwi6za': {
      'en': 'Field is required',
      'hi': '',
    },
    'l88z86il': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    '3p1kacj4': {
      'en': 'Home',
      'hi': '',
    },
  },
  // allchats
  {
    'io9l5znu': {
      'en': 'Chats',
      'hi': '',
    },
    '95ihqgf3': {
      'en': 'Chat',
      'hi': '',
    },
  },
  // paymentsuccess
  {
    '3gz8mrkw': {
      'en': 'Welcome to Fun circle membership',
      'hi': '',
    },
    '1947j5zz': {
      'en': 'You are now member of ',
      'hi': '',
    },
    'kbqrr0fg': {
      'en': 'Fun circle',
      'hi': '',
    },
    'qryoz5yp': {
      'en': 'Subscribed',
      'hi': '',
    },
    'a0lrj5z3': {
      'en': 'Payment via Store',
      'hi': '',
    },
    '9icv0ll9': {
      'en': 'You unlocked these',
      'hi': '',
    },
    'yyv77ly9': {
      'en': '7X Faster new recommendations',
      'hi': '',
    },
    '7mgdtg6q': {
      'en': '7X',
      'hi': '',
    },
    '2bafh8ql': {
      'en': 'Unlock new recommendations in just 12 hours',
      'hi': '',
    },
    '71mmb13e': {
      'en': 'Unlock 7 recommendations',
      'hi': '',
    },
    '9ek1e16b': {
      'en': 'Top',
      'hi': '',
    },
    '1a1a0i71': {
      'en':
          'Unlock up to seven carefully curated recommendations, surpassing the standard limit of four for greater dating possibilities.',
      'hi': '',
    },
    '4bmpt1f8': {
      'en': 'We recommend you to more people',
      'hi': '',
    },
    '4iejdf9u': {
      'en':
          'Premium users enjoy heightened visibility, ensuring your profile stands out in the crowd for more meaningful connections.',
      'hi': '',
    },
    'fv78wpnr': {
      'en': 'Search by your preferences',
      'hi': '',
    },
    '8vnpwvca': {
      'en':
          'Premium users gain access to advanced search features for a more refined and tailored exploration of potential connections.',
      'hi': '',
    },
    '52j5pe27': {
      'en': 'See secrets of other people',
      'hi': '',
    },
    'g9crjrm9': {
      'en':
          'Access exclusive secret fields about your matches by opting for our premium service—because some things are worth the intrigue.',
      'hi': '',
    },
    'p4ka86g9': {
      'en': 'Take control of your profile!',
      'hi': '',
    },
    'p45oc3s8': {
      'en':
          'Premium users can hide specific profile elements, ensuring a tailored and personalized experience in the dating journey.',
      'hi': '',
    },
    'lesnamt7': {
      'en': 'You unlocked these',
      'hi': '',
    },
    '5xqgsugq': {
      'en': 'Book 8 slots per month',
      'hi': '',
    },
    'ey4tns5l': {
      'en': 'Top',
      'hi': '',
    },
    'z5jhfr33': {
      'en': 'You can join any nearby meets for free—no additional fees.',
      'hi': '',
    },
    'exiw2dlf': {
      'en': 'Current sport - Badminton',
      'hi': '',
    },
    'ietlrh9y': {
      'en': 'Go with someone who also wants to go with someone. ',
      'hi': '',
    },
    'pohkertl': {
      'en': '2 of those slots can be used by friends',
      'hi': '',
    },
    'dzsgjvoj': {
      'en': 'Top',
      'hi': '',
    },
    't66ihy6p': {
      'en': 'Premium members can create groups for their specific interests',
      'hi': '',
    },
    'wn0wfios': {
      'en': 'Pre-book',
      'hi': '',
    },
    'kuzbpbgv': {
      'en': 'Premium members can see and join premium groups',
      'hi': '',
    },
    'm24xa3kl': {
      'en': 'Will work on evening slots too!',
      'hi': '',
    },
    'wbnpcne7': {
      'en': 'You can join any outdoor sports activity for free. ',
      'hi': '',
    },
    'h3ttb5lh': {
      'en': 'FILL IN YOUR PREFERENCE',
      'hi': '',
    },
    'bdl3rb61': {
      'en': 'Home',
      'hi': '',
    },
  },
  // groupfilters
  {
    'f2jmgvht': {
      'en': 'Apply Filters',
      'hi': '',
    },
    'qu4h7kmf': {
      'en':
          'To change the category type, switch from the tab bar and then use filter.',
      'hi': '',
    },
    'bgzfw17z': {
      'en': 'Premium',
      'hi': '',
    },
    'jzvkdvkf': {
      'en': 'Show only premium groups',
      'hi': '',
    },
    'fh025lpi': {
      'en': 'Show near',
      'hi': '',
    },
    'kuy14017': {
      'en': 'Only nearby groups will be shown.',
      'hi': '',
    },
    'gv9cyr0b': {
      'en': 'Choose Interests',
      'hi': '',
    },
    't1z5qj6k': {
      'en': 'Self Care',
      'hi': '',
    },
    'gt4eopon': {
      'en': 'Running',
      'hi': '',
    },
    '6db2glbu': {
      'en': 'Gym',
      'hi': '',
    },
    'ab8sjpjv': {
      'en': 'Physical fitness',
      'hi': '',
    },
    '35odajek': {
      'en': 'Hygiene',
      'hi': '',
    },
    'rrfqkby4': {
      'en': 'Muscle relaxation',
      'hi': '',
    },
    'l2su8ujg': {
      'en': 'Meditation',
      'hi': '',
    },
    'm66zqpyh': {
      'en': 'Healthy cooking',
      'hi': '',
    },
    '31luunft': {
      'en': 'Yoga',
      'hi': '',
    },
    'fgu5jr5p': {
      'en': 'Reading ',
      'hi': '',
    },
    't9m954jc': {
      'en': 'Sports',
      'hi': '',
    },
    'h5kcv93v': {
      'en': 'Basketball',
      'hi': '',
    },
    '0mtoiyho': {
      'en': 'Cricket',
      'hi': '',
    },
    '1yokpv17': {
      'en': 'Soccer',
      'hi': '',
    },
    '31zrdpjs': {
      'en': 'Tennis',
      'hi': '',
    },
    'qp6mlsl4': {
      'en': 'Swimming',
      'hi': '',
    },
    '2kahxw7t': {
      'en': 'Volleyball',
      'hi': '',
    },
    'pa8khk76': {
      'en': 'Cycling',
      'hi': '',
    },
    '1nssib42': {
      'en': 'Golf',
      'hi': '',
    },
    'p3bq0kgv': {
      'en': 'Baseball',
      'hi': '',
    },
    '04p46d3p': {
      'en': 'Music',
      'hi': '',
    },
    'c66gvkk0': {
      'en': 'Rock',
      'hi': '',
    },
    'a5vt0b5j': {
      'en': 'Jazz',
      'hi': '',
    },
    'asz1hg3n': {
      'en': 'Soft',
      'hi': '',
    },
    'ticldcf9': {
      'en': 'Lo-fi',
      'hi': '',
    },
    'y6uwibio': {
      'en': 'English',
      'hi': '',
    },
    'g5w4c3ir': {
      'en': 'Hindi',
      'hi': '',
    },
    'vur4306u': {
      'en': 'Playing an instrument',
      'hi': '',
    },
    '8y25fkw6': {
      'en': 'Singing',
      'hi': '',
    },
    'ivh5j1i3': {
      'en': 'Hip-hop',
      'hi': '',
    },
    'ov4w1hu1': {
      'en': 'Electronic music',
      'hi': '',
    },
    '5wg72kqd': {
      'en': 'Pop music',
      'hi': '',
    },
    'qtz5bkje': {
      'en': 'Folk music',
      'hi': '',
    },
    '7qgvso1r': {
      'en': 'Art and Creativity',
      'hi': '',
    },
    'iet0q45r': {
      'en': 'Paint',
      'hi': '',
    },
    'qpwqg5bs': {
      'en': 'Photography',
      'hi': '',
    },
    '8ak1zcsw': {
      'en': 'Videography',
      'hi': '',
    },
    '3ike0cvo': {
      'en': 'Abstact',
      'hi': '',
    },
    '08lxgfyn': {
      'en': 'Therater',
      'hi': '',
    },
    '3uq2iyc6': {
      'en': 'Drawing and sketching',
      'hi': '',
    },
    '60yzl2b8': {
      'en': 'Graphic design',
      'hi': '',
    },
    'bosoqhrd': {
      'en': 'Creative writing',
      'hi': '',
    },
    '4sfvoll4': {
      'en': 'Pottery',
      'hi': '',
    },
    'l0k2ed52': {
      'en': 'DIY crafts\n',
      'hi': '',
    },
    'o6gclsps': {
      'en': 'Pets',
      'hi': '',
    },
    'xkk3hhkz': {
      'en': 'Dog',
      'hi': '',
    },
    '53rllp1n': {
      'en': 'Cat',
      'hi': '',
    },
    '48v6sxis': {
      'en': 'Bird',
      'hi': '',
    },
    's71hz45u': {
      'en': 'Fish',
      'hi': '',
    },
    '52ihdoh5': {
      'en': 'Pet grooming',
      'hi': '',
    },
    'nvp9n30l': {
      'en': 'Exotic pets',
      'hi': '',
    },
    '6a2muu9j': {
      'en': 'Horseback riding',
      'hi': '',
    },
    '2i7xgxk7': {
      'en': 'Outdoor Activities',
      'hi': '',
    },
    'aran4sc3': {
      'en': 'Hiking',
      'hi': '',
    },
    'zx2wxfds': {
      'en': 'Biking',
      'hi': '',
    },
    'uzlvb6uv': {
      'en': 'Traveling',
      'hi': '',
    },
    '0ut9hm8m': {
      'en': 'Explorer',
      'hi': '',
    },
    'qaklrnuz': {
      'en': 'Camping',
      'hi': '',
    },
    'gwtnsgqy': {
      'en': 'Stargazing',
      'hi': '',
    },
    'r8dt61b8': {
      'en': 'Fishing',
      'hi': '',
    },
    'xhmtjr8c': {
      'en': 'Rock climbing',
      'hi': '',
    },
    'e9rnr1po': {
      'en': 'Gardening',
      'hi': '',
    },
    'qhev2f02': {
      'en': 'Spirituality and Mindfulness',
      'hi': '',
    },
    '4wp8uwld': {
      'en': 'Meditation',
      'hi': '',
    },
    'c513kix8': {
      'en': 'Yoga',
      'hi': '',
    },
    'h086pwnl': {
      'en': 'Spiritual communities',
      'hi': '',
    },
    'e2neh1en': {
      'en': 'Prayer',
      'hi': '',
    },
    'vh4rzu5t': {
      'en': 'Retreats',
      'hi': '',
    },
    '4qi42u2b': {
      'en': 'Astrology',
      'hi': '',
    },
    'uthuzp3s': {
      'en': 'Tarot reading',
      'hi': '',
    },
    'y5etwmna': {
      'en': 'Apply Filters',
      'hi': '',
    },
    'gr9wkfe3': {
      'en': 'Home',
      'hi': '',
    },
  },
  // likedusers
  {
    '9h3frnt5': {
      'en': 'You can only connect with Subscription',
      'hi': '',
    },
    'msdpc68q': {
      'en': 'Subscribe Now',
      'hi': '',
    },
    'kjund988': {
      'en': 'You Liked',
      'hi': '',
    },
    'ln2zslph': {
      'en': 'Others Liked',
      'hi': '',
    },
    'zto7yyzy': {
      'en': 'Likes',
      'hi': '',
    },
    'w6ymnx3j': {
      'en': 'Home',
      'hi': '',
    },
  },
  // settings
  {
    'qt6x617v': {
      'en': 'Unsubscribe from Sms/Email',
      'hi': '',
    },
    '10b1030s': {
      'en': 'Terms and Conditions',
      'hi': '',
    },
    'l3nll4a6': {
      'en': 'Shipping and Delivery',
      'hi': '',
    },
    'm2muhgzi': {
      'en': 'Cancellation and Refund',
      'hi': '',
    },
    'qxl96tap': {
      'en': 'About Us',
      'hi': '',
    },
    'g6dhh0x3': {
      'en': 'Privacy Policy',
      'hi': '',
    },
    'up9dnjsf': {
      'en': 'Push notifications',
      'hi': '',
    },
    'lrfvbjx6': {
      'en': 'Delete account',
      'hi': '',
    },
    '2jkwo480': {
      'en': 'Follow us on',
      'hi': '',
    },
    'cg0nni2v': {
      'en': 'App Versions',
      'hi': '',
    },
    'kxiuckvx': {
      'en': 'v4.0.x',
      'hi': '',
    },
    'iigltbe9': {
      'en': 'Log Out',
      'hi': '',
    },
    'lfw14gf2': {
      'en': 'Settings',
      'hi': '',
    },
    '5tkwucs2': {
      'en': 'Home',
      'hi': '',
    },
  },
  // helpcenter
  {
    'ppwt4l68': {
      'en': 'Contact us',
      'hi': '',
    },
    'k0ajyr2l': {
      'en': 'FAQs',
      'hi': '',
    },
    'ofriece7': {
      'en': 'Safety Tips',
      'hi': '',
    },
    'i25b9pcv': {
      'en': 'Contact us Via',
      'hi': '',
    },
    '3shrzu0a': {
      'en': 'Help Center',
      'hi': '',
    },
    'tl2398ik': {
      'en': 'Home',
      'hi': '',
    },
  },
  // notifications
  {
    '683ub2m3': {
      'en': 'Notifications',
      'hi': '',
    },
    'iilcx2vq': {
      'en': 'Home',
      'hi': '',
    },
  },
  // webview
  {
    '4zjms33l': {
      'en': 'Home',
      'hi': '',
    },
  },
  // accesslocation
  {
    'v4f99gm9': {
      'en': 'Where are you?',
      'hi': '',
    },
    '06x7hkqp': {
      'en':
          'We need your location for registration and give you accurate data.',
      'hi': '',
    },
    'x13jbvvb': {
      'en': 'Enable Location',
      'hi': '',
    },
    'to0wvgsg': {
      'en': 'Home',
      'hi': '',
    },
  },
  // createtickets
  {
    '0l88v8xq': {
      'en': 'RSVP/FREE',
      'hi': '',
    },
    '59krcm3e': {
      'en': 'Add New',
      'hi': '',
    },
    '790a78k2': {
      'en': 'Paid',
      'hi': '',
    },
    '0zyg28kt': {
      'en': 'Add New',
      'hi': '',
    },
    'pit4ew1d': {
      'en': 'Next',
      'hi': '',
    },
    'zhwygp98': {
      'en': 'Tickets',
      'hi': '',
    },
    'x30ns535': {
      'en': 'Home',
      'hi': '',
    },
  },
  // mygroups
  {
    '2dw0c3l3': {
      'en': 'My Groups',
      'hi': '',
    },
    'fgmlu03e': {
      'en': 'Create venue',
      'hi': '',
    },
    '1irn4ath': {
      'en': 'Search',
      'hi': '',
    },
    'ahew3y95': {
      'en': 'Seach group',
      'hi': '',
    },
    'by9rpgtq': {
      'en': 'Send notification',
      'hi': '',
    },
    'yefvtbo3': {
      'en': 'EXCLUSIVE',
      'hi': '',
    },
    'uo8cycft': {
      'en': 'See Tickets',
      'hi': '',
    },
    '76etof5n': {
      'en': 'Published',
      'hi': '',
    },
    'hp5qgpsr': {
      'en': 'Edit',
      'hi': '',
    },
    '0b0l8b7g': {
      'en': 'Sales',
      'hi': '',
    },
    'f4za5fea': {
      'en': 'Home',
      'hi': '',
    },
  },
  // booktickets
  {
    'tf5mopyu': {
      'en': 'Go to Maps',
      'hi': '',
    },
    'od6dvp7p': {
      'en': 'Court Share (Total price / 4)',
      'hi': '',
    },
    'e83jh7dq': {
      'en': '+15 rs service fee.',
      'hi': '',
    },
    'yop182s3': {
      'en': 'See who joined',
      'hi': '',
    },
    'p28egvd0': {
      'en': 'Who can Join',
      'hi': '',
    },
    'usfkun2g': {
      'en': 'Warning : ',
      'hi': '',
    },
    'lhg2j5wa': {
      'en':
          'Players will have to bring their own shuttle and play with coordination of others. Non-compliants will be restricted.\n\nPlease book only if you match the level listed above. Incorrect bookings affect game quality for everyone. If your level does not match, we may ask you to switch slots.',
      'hi': '',
    },
    '59nv1m0s': {
      'en': 'Description',
      'hi': '',
    },
    'qr5ikf2m': {
      'en': 'Total',
      'hi': '',
    },
    'y3fazk49': {
      'en': 'Home',
      'hi': '',
    },
  },
  // myticket
  {
    'hrg52jhe': {
      'en': 'Ticket ID',
      'hi': '',
    },
    'ejenhp2b': {
      'en': 'Venue details',
      'hi': '',
    },
    'rlbfr0vd': {
      'en': 'Maps',
      'hi': '',
    },
    'ho7cjetb': {
      'en': 'Need help? Messages us',
      'hi': '',
    },
    'n9t5z58p': {
      'en': 'Terms and conditions',
      'hi': '',
    },
    '2dgoriip': {
      'en': 'My Ticket',
      'hi': '',
    },
    'q9naxm4s': {
      'en': 'Home',
      'hi': '',
    },
  },
  // mytickets
  {
    'rr4nnul5': {
      'en': 'Need help? Messages us',
      'hi': '',
    },
    'kcqlgu56': {
      'en': 'Terms and conditions',
      'hi': '',
    },
    '29mlyrkz': {
      'en': 'My Tickets',
      'hi': '',
    },
    'wl5hh9kn': {
      'en': 'Home',
      'hi': '',
    },
  },
  // editgroups
  {
    'tr18uxm2': {
      'en': 'Primary',
      'hi': '',
    },
    'wjy0pdmr': {
      'en': 'Set as Primary',
      'hi': '',
    },
    'o2e5ckh7': {
      'en': 'Set as Primary',
      'hi': '',
    },
    'go1rvue0': {
      'en': 'Set as Primary',
      'hi': '',
    },
    'z2q6b330': {
      'en': 'Set as Primary',
      'hi': '',
    },
    '84h8dtgx': {
      'en': 'Save Images',
      'hi': '',
    },
    'r6xcygt2': {
      'en': 'Enter group name',
      'hi': '',
    },
    'ceiuxs3b': {
      'en': 'Select location',
      'hi': '',
    },
    '0t5o7n08': {
      'en': 'Group Description',
      'hi': '',
    },
    'ul0i0loz': {
      'en': 'Field is required',
      'hi': '',
    },
    'hapw6pre': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'j168rjq2': {
      'en': 'Field is required',
      'hi': '',
    },
    '8kslgzu1': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    '2n0dl62p': {
      'en': 'Edit interests',
      'hi': '',
    },
    'mvm3sun8': {
      'en': 'Art',
      'hi': '',
    },
    'fya5ll38': {
      'en': 'Museums & galleries',
      'hi': '',
    },
    'jfvowzj0': {
      'en': 'Coffee',
      'hi': '',
    },
    '5n820dtl': {
      'en': 'Cat',
      'hi': '',
    },
    'ahldmp6s': {
      'en': 'Movie',
      'hi': '',
    },
    '2whtzr5t': {
      'en': 'Dog',
      'hi': '',
    },
    'n80y03pd': {
      'en': 'Travel',
      'hi': '',
    },
    '5pf7eord': {
      'en': 'Save',
      'hi': '',
    },
    'urmbfqm8': {
      'en': 'Edit group',
      'hi': '',
    },
    'whr7k2v1': {
      'en': 'Home',
      'hi': '',
    },
  },
  // groupordating
  {
    'r7cwzhkg': {
      'en': '28%',
      'hi': '',
    },
    'xdkcxp9y': {
      'en': 'Why are you here',
      'hi': '',
    },
    'ou958lx8': {
      'en': 'Dating',
      'hi': '',
    },
    '92rzjcui': {
      'en': 'Groups &\nEvents',
      'hi': '',
    },
    'uo5e1x9b': {
      'en': 'Still open for dating?',
      'hi': '',
    },
    '6znr5or6': {
      'en': 'Yes',
      'hi': '',
    },
    '6ay3c953': {
      'en': 'No',
      'hi': '',
    },
    'nmkmcea8': {
      'en': 'You can still do both, or change later.',
      'hi': '',
    },
    'ayzlhze3': {
      'en': 'Home',
      'hi': '',
    },
  },
  // likesbyrecommended
  {
    '4jhvrozc': {
      'en': 'Wanna go together ?',
      'hi': '',
    },
    'zygcuwny': {
      'en': 'When a user shows interest in your request, it will appear here.',
      'hi': '',
    },
    'q8cm5bij': {
      'en': 'Go to requests',
      'hi': '',
    },
    'j8o2ng10': {
      'en': 'Request check',
      'hi': '',
    },
    'ysuquq83': {
      'en': 'Requests',
      'hi': '',
    },
    '25w1n6zn': {
      'en': 'Request',
      'hi': '',
    },
  },
  // Requests
  {
    'jns66bax': {
      'en': 'All requests',
      'hi': '',
    },
    'i38ihvun': {
      'en': 'View Profile',
      'hi': '',
    },
    'pagodh5p': {
      'en': 'Can Join',
      'hi': '',
    },
    'hiqdsl4a': {
      'en': 'My Requests',
      'hi': '',
    },
    'iesb3lhy': {
      'en': 'Can Join',
      'hi': '',
    },
    'o9g941m9': {
      'en': 'See intrested people',
      'hi': '',
    },
    '5y278br1': {
      'en': 'Requests',
      'hi': '',
    },
    'suc4x1pz': {
      'en': 'Post a request',
      'hi': '',
    },
    'iq8haslv': {
      'en': 'Home',
      'hi': '',
    },
  },
  // postrequest
  {
    'chuyomm4': {
      'en': 'Description',
      'hi': '',
    },
    'oddvxw31': {
      'en': 'Members Needed',
      'hi': '',
    },
    'hbe9a716': {
      'en': 'Field is required',
      'hi': '',
    },
    'd22jls46': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    '66qmzb8r': {
      'en': 'Post a request',
      'hi': '',
    },
    'ho7t911n': {
      'en': 'Post a request',
      'hi': '',
    },
    'suw06s2v': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Myrequests
  {
    'k60d5a96': {
      'en': 'Can Join',
      'hi': '',
    },
    '8t9ij6d7': {
      'en': 'See intrested people',
      'hi': '',
    },
    '1af9nzck': {
      'en': 'My requests',
      'hi': '',
    },
    'itmte9fn': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Interestedpeople
  {
    '60x973g5': {
      'en': 'Intrested',
      'hi': '',
    },
    'bmfzdzmh': {
      'en': 'View Profile',
      'hi': '',
    },
    'o4dbtmi2': {
      'en': 'Home',
      'hi': '',
    },
  },
  // myinterestedrequests
  {
    'zdfis4ke': {
      'en': 'View Profile',
      'hi': '',
    },
    '7gfs6ocp': {
      'en': 'Can Join',
      'hi': '',
    },
    'yrus9ta6': {
      'en': 'My interested requests',
      'hi': '',
    },
    'c61bnj31': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Createticketgroups
  {
    'imiymkyb': {
      'en': 'Ticket name',
      'hi': '',
    },
    's9fprj4r': {
      'en': 'Capacity',
      'hi': '',
    },
    'i1dl76l9': {
      'en': 'Single ticket',
      'hi': '',
    },
    't6g4t88i': {
      'en': 'Please select...',
      'hi': '',
    },
    'zn0phsll': {
      'en': 'Search for an item...',
      'hi': '',
    },
    'sqazh5w3': {
      'en': 'Single ticket',
      'hi': '',
    },
    'nfg9pose': {
      'en': 'Group ticket',
      'hi': '',
    },
    'z5tollpm': {
      'en': 'Select Venue',
      'hi': '',
    },
    'e1qj8rim': {
      'en': 'Sample Venue',
      'hi': '',
    },
    'pbyhk97e': {
      'en': 'Sample Venue',
      'hi': '',
    },
    'y3grj163': {
      'en': 'Search for venues',
      'hi': '',
    },
    'yrzklumq': {
      'en': 'Cultural',
      'hi': '',
    },
    'vjxi3fv1': {
      'en': 'Charity',
      'hi': '',
    },
    '72yrcdh3': {
      'en': 'Education',
      'hi': '',
    },
    '82q9m4s6': {
      'en': 'Workshops',
      'hi': '',
    },
    'clooo494': {
      'en': 'Music Events',
      'hi': '',
    },
    'kodlv9w6': {
      'en': 'Comedy Events',
      'hi': '',
    },
    '17k9knms': {
      'en': 'Visual Arts',
      'hi': '',
    },
    '5yihsqf1': {
      'en': 'Religion and Sprituality',
      'hi': '',
    },
    'jrdgqpyd': {
      'en': 'Festival & Fair',
      'hi': '',
    },
    '4b1v2gwa': {
      'en': 'Home Concerts',
      'hi': '',
    },
    'xo1oe7q8': {
      'en': 'Poetry Events',
      'hi': '',
    },
    'c07avh4x': {
      'en': 'Award Show ',
      'hi': '',
    },
    'jue6zip2': {
      'en': 'Conference',
      'hi': '',
    },
    't98y6jiq': {
      'en': 'New year 2024',
      'hi': '',
    },
    'df90pegi': {
      'en': 'Movie Screening ',
      'hi': '',
    },
    'ypmi0ikc': {
      'en': 'Sports',
      'hi': '',
    },
    'sjv1bu98': {
      'en': 'Explore',
      'hi': '',
    },
    'fxct7oix': {
      'en': 'Foodies',
      'hi': '',
    },
    '8ssgrsi4': {
      'en': 'Buddies',
      'hi': '',
    },
    'b89jw3zh': {
      'en': 'Books& Literature',
      'hi': '',
    },
    '8brow68n': {
      'en': 'Art and Craft',
      'hi': '',
    },
    'hr492y75': {
      'en': 'Gaming',
      'hi': '',
    },
    'ubtzmfng': {
      'en': 'Pets',
      'hi': '',
    },
    's99gnrgn': {
      'en': 'Coding and Tech',
      'hi': '',
    },
    'p0353hki': {
      'en': 'Fitness',
      'hi': '',
    },
    'h6wiy23d': {
      'en': 'Volunteering',
      'hi': '',
    },
    'rde51ytb': {
      'en': 'Hiking',
      'hi': '',
    },
    'hbsgj2fz': {
      'en': 'Trips',
      'hi': '',
    },
    'xmrg1hsp': {
      'en': '2',
      'hi': '',
    },
    'bicvtyik': {
      'en': 'Ticket per group',
      'hi': '',
    },
    '0zuaz2a1': {
      'en': 'Search for an item...',
      'hi': '',
    },
    '8p9tkuy8': {
      'en': '2',
      'hi': '',
    },
    'kpm2brzc': {
      'en': '3',
      'hi': '',
    },
    'w56gtat5': {
      'en': '4',
      'hi': '',
    },
    'rudlc95f': {
      'en': '5',
      'hi': '',
    },
    'l4g97w8c': {
      'en': '6',
      'hi': '',
    },
    '9v3d1oia': {
      'en': 'Price',
      'hi': '',
    },
    'sv1o7hq8': {
      'en': '₹',
      'hi': '',
    },
    'hwks3fb4': {
      'en': 'Price should be under ₹500',
      'hi': '',
    },
    '70plgev5': {
      'en': 'Description / Additional info',
      'hi': '',
    },
    'f7lqs1l8': {
      'en': 'Field is required',
      'hi': '',
    },
    '147rizp6': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    '78yl9kfm': {
      'en': 'Field is required',
      'hi': '',
    },
    'aesbp182': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'v2kvl4sv': {
      'en': 'Field is required',
      'hi': '',
    },
    '8hmg4fns': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    '3rjmj5en': {
      'en': 'Save',
      'hi': '',
    },
    'ddqo52bl': {
      'en': 'Create tickets',
      'hi': '',
    },
    '0fkhv85f': {
      'en': 'Home',
      'hi': '',
    },
  },
  // seewhojoined
  {
    '3mhh8j8c': {
      'en': 'See who joined',
      'hi': '',
    },
    'nh8bt4et': {
      'en': 'Home',
      'hi': '',
    },
  },
  // ticketwebview
  {
    'em9pbzxg': {
      'en': 'Home',
      'hi': '',
    },
  },
  // secretfields
  {
    'rd8bmki6': {
      'en': 'answer here...',
      'hi': '',
    },
    'k9q566c0': {
      'en': 'Field is required',
      'hi': '',
    },
    'zx9rpx6g': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'q8uo3c6p': {
      'en': 'Home',
      'hi': '',
    },
  },
  // reportaglitch
  {
    'c2wpjeoc': {
      'en': 'You are helpful',
      'hi': '',
    },
    'ahjpipur': {
      'en':
          'Report a glitch which you want to be fixed. We will become good together.',
      'hi': '',
    },
    '8fx5rlir': {
      'en': 'Glitch details',
      'hi': '',
    },
    's332x6px': {
      'en': 'Field is required',
      'hi': '',
    },
    'my95f6vu': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'xrxxefdr': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Sales
  {
    'jl3kam70': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Createvenue
  {
    'ymitfep5': {
      'en': 'Create venue',
      'hi': '',
    },
    'n9mhhj4j': {
      'en': 'Enter venue name',
      'hi': '',
    },
    'ov5r9gsw': {
      'en': 'Venue maps link',
      'hi': '',
    },
    'twnk42b1': {
      'en': 'Select Location',
      'hi': '',
    },
    'ndu5t8u4': {
      'en': 'Venue Description',
      'hi': '',
    },
    '8m317d54': {
      'en': 'Add Images',
      'hi': '',
    },
    'rqpsv3t6': {
      'en': 'Cover Pic',
      'hi': '',
    },
    'cy955kol': {
      'en': 'Set as Primary',
      'hi': '',
    },
    '6jlma3of': {
      'en': 'Set as Primary',
      'hi': '',
    },
    'ykqs4rdl': {
      'en': 'Set as Primary',
      'hi': '',
    },
    'keix3fl6': {
      'en': 'Set as Primary',
      'hi': '',
    },
    's39nxkh1': {
      'en': 'Field is required',
      'hi': '',
    },
    'mmx9v0zy': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'rrnprnvu': {
      'en': 'Field is required',
      'hi': '',
    },
    'e1nnxpt7': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    '78f4h725': {
      'en': 'Create Venue',
      'hi': '',
    },
    '1og6a0wk': {
      'en': 'Home',
      'hi': '',
    },
  },
  // EditTicket
  {
    'scsh3cg6': {
      'en': 'Edit ticket',
      'hi': '',
    },
    '3hviee19': {
      'en': 'Ticket info',
      'hi': '',
    },
    'tc3yymvf': {
      'en': 'Take action',
      'hi': '',
    },
    'aifbu05o': {
      'en': 'Search...',
      'hi': '',
    },
    '0wk5uxc7': {
      'en': 'Mark as completed',
      'hi': '',
    },
    'txvf9ti2': {
      'en': 'Remove user',
      'hi': '',
    },
    'c0xyj2jg': {
      'en': 'Message',
      'hi': '',
    },
    'o35bcxh6': {
      'en': 'Cover Pic',
      'hi': '',
    },
    'ff0p8v3d': {
      'en': 'Home',
      'hi': '',
    },
  },
  // sendNotification
  {
    'qir442t0': {
      'en': 'Send notification',
      'hi': '',
    },
    'ucryosww': {
      'en': 'Notification Title',
      'hi': '',
    },
    'sjmuzndb': {
      'en': 'Badminton game is listed',
      'hi': '',
    },
    '4zjtbqwx': {
      'en': 'Notification text',
      'hi': '',
    },
    'pdzpfm0a': {
      'en': 'For sunday at 10am, JOIN NOW',
      'hi': '',
    },
    'et91cfem': {
      'en': 'Group ID',
      'hi': '',
    },
    '8zc5jbd5': {
      'en': '90',
      'hi': '',
    },
    'jlzb2nhi': {
      'en': 'Group name',
      'hi': '',
    },
    'tmrl6s7s': {
      'en': 'Badminton Gurugram',
      'hi': '',
    },
    'xx4ut4x6': {
      'en': 'Send notification',
      'hi': '',
    },
    '4b9i53p0': {
      'en': 'Home',
      'hi': '',
    },
  },
  // slots
  {
    'bhm0a3eq': {
      'en': 'Gurugram',
      'hi': '',
    },
    'zw1mijrg': {
      'en': 'Badminton',
      'hi': '',
    },
    '9084hw31': {
      'en': 'Pickleball',
      'hi': '',
    },
    'it3a4xeb': {
      'en': 'Badminton',
      'hi': '',
    },
    't29en3ey': {
      'en': '',
      'hi': '',
    },
    'dipdljgy': {
      'en': '',
      'hi': '',
    },
    'l958u7h3': {
      'en': 'Home',
      'hi': '',
    },
  },
  // subscriptionquestions
  {
    'inae9lcs': {
      'en': 'Fill in these details so that we can serve you better',
      'hi': '',
    },
    'hsxqtdlc': {
      'en': 'Select preferred venue',
      'hi': '',
    },
    'oa4zoh12': {
      'en': 'Search...',
      'hi': '',
    },
    'hfcuxz2e': {
      'en': 'Option 1',
      'hi': '',
    },
    '0d8k5fog': {
      'en': 'Option 2',
      'hi': '',
    },
    '8z2bdath': {
      'en': 'Option 3',
      'hi': '',
    },
    'kfew0amf': {
      'en': 'Preferred time slot',
      'hi': '',
    },
    'ka1fpsek': {
      'en': 'Option 1',
      'hi': '',
    },
    '5fy2whvk': {
      'en': 'Option 2',
      'hi': '',
    },
    '2yzepuyl': {
      'en': 'Option 3',
      'hi': '',
    },
    '10ozz11o': {
      'en': 'Preferred days',
      'hi': '',
    },
    'a26szfqi': {
      'en': 'Monday',
      'hi': '',
    },
    '2biquur8': {
      'en': 'Tuesday',
      'hi': '',
    },
    'qq53q4pn': {
      'en': 'Wednesday',
      'hi': '',
    },
    'vp4vak20': {
      'en': 'Thursday',
      'hi': '',
    },
    'okwu79mz': {
      'en': 'Friday',
      'hi': '',
    },
    'j6vmmg0h': {
      'en': 'Saturday',
      'hi': '',
    },
    '4ix3drj0': {
      'en': 'Sunday',
      'hi': '',
    },
    'by2po1f5': {
      'en': 'Skill level',
      'hi': '',
    },
    'il3rflfq': {
      'en': 'Beginner',
      'hi': '',
    },
    'uibv7fom': {
      'en': 'Intermediate',
      'hi': '',
    },
    'xxwm39tv': {
      'en': 'Advanced',
      'hi': '',
    },
    '230hmowm': {
      'en': 'Any special requests or concerns?',
      'hi': '',
    },
    'qo2zd023': {
      'en': 'Done, let\'s play!',
      'hi': '',
    },
    '7me5y006': {
      'en': 'Home',
      'hi': '',
    },
  },
  // homepagewebview
  {
    'uwhey3sm': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Play
  {
    'fbtt3xej': {
      'en': 'Games',
      'hi': '',
    },
    'i9hmbi25': {
      'en': 'Badminton',
      'hi': '',
    },
    '2x2p6i0i': {
      'en': 'Pickleball',
      'hi': '',
    },
    '4hmpkz0u': {
      'en': 'Play',
      'hi': '',
    },
  },
  // Venues
  {
    'l3cdsf66': {
      'en': 'Badminton',
      'hi': '',
    },
    'nqj4n908': {
      'en': 'Pickleball',
      'hi': '',
    },
    '6v0cr12s': {
      'en': 'Venues',
      'hi': '',
    },
  },
  // Profile
  {
    'jnshgftm': {
      'en': 'Profile',
      'hi': '',
    },
    'duwm7gr2': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Mygroupsweb
  {
    'cnq2z77d': {
      'en': 'My groups',
      'hi': '',
    },
    'be6slcf9': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Bookingsweb
  {
    'dbxnllgz': {
      'en': 'Bookings',
      'hi': '',
    },
    'rrwnwl4b': {
      'en': 'Home',
      'hi': '',
    },
  },
  // duoconnectionsweb
  {
    '9u4pwap5': {
      'en': 'Duos',
      'hi': '',
    },
    '8f1v8my1': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Requestsweb
  {
    's34uhft9': {
      'en': 'Game Requests',
      'hi': '',
    },
    'nzf8t198': {
      'en': 'Home',
      'hi': '',
    },
  },
  // editprofileweb
  {
    'mjdh5lvo': {
      'en': 'Edit Profile',
      'hi': '',
    },
    'tsjlcy2m': {
      'en': 'Home',
      'hi': '',
    },
  },
  // HomeNew
  {
    'gw2i3kag': {
      'en': 'My Groups',
      'hi': '',
    },
    'j1mjxljf': {
      'en': 'Explore venues',
      'hi': '',
    },
    'cymorick': {
      'en': 'Explore groups and venues',
      'hi': '',
    },
    'wp4krhz6': {
      'en': 'Daily Games',
      'hi': '',
    },
    'dlluqiix': {
      'en': 'Go to daily games happening near you',
      'hi': '',
    },
    'e1aagha6': {
      'en': 'Venues Near You',
      'hi': '',
    },
    'vf7sv3s3': {
      'en': 'Badminton',
      'hi': '',
    },
    'jjgj6gy1': {
      'en': 'Pickleball',
      'hi': '',
    },
    'gq75pxqu': {
      'en': 'Badminton',
      'hi': '',
    },
    'ac7w3ipb': {
      'en': 'Join group',
      'hi': '',
    },
    'ub9x07j6': {
      'en': 'Home',
      'hi': '',
    },
  },
  // VenuesNew
  {
    'dghnk4n4': {
      'en': 'Gurugram',
      'hi': '',
    },
    's35nvmad': {
      'en': 'Badminton',
      'hi': '',
    },
    'vcj358ro': {
      'en': 'Pickleball',
      'hi': '',
    },
    'zfx71e7z': {
      'en': 'Badminton',
      'hi': '',
    },
    'sip4902z': {
      'en': 'Venue name',
      'hi': '',
    },
    '7t7b9oco': {
      'en': 'Join group',
      'hi': '',
    },
    'd1rkoy8i': {
      'en': 'Join group',
      'hi': '',
    },
    '5ig5w6o5': {
      'en': 'Home',
      'hi': '',
    },
  },
  // SingleVenueNew
  {
    'wt0wh086': {
      'en': 'Venue',
      'hi': '',
    },
    'nhemn2k7': {
      'en': 'Join group',
      'hi': '',
    },
    '3zv06upm': {
      'en': 'Choose level',
      'hi': '',
    },
    'kybfovk8': {
      'en': 'Select your playing level to continue.',
      'hi': '',
    },
    'f49zcsqs': {
      'en': 'Level 1',
      'hi': '',
    },
    'fy25eoa7': {
      'en': 'Level 2',
      'hi': '',
    },
    'paufo96j': {
      'en': 'Level 3',
      'hi': '',
    },
    'x4ypeprz': {
      'en': 'Level 4',
      'hi': '',
    },
    'ai5rd8ji': {
      'en': 'Cancel',
      'hi': '',
    },
    'gs0oh5b3': {
      'en': 'Home',
      'hi': '',
    },
  },
  // playnew
  {
    'q24dshym': {
      'en': 'Gurugram',
      'hi': '',
    },
    'd9rhkeq9': {
      'en': 'Badminton',
      'hi': '',
    },
    'wkqc3l5e': {
      'en': 'Pickleball',
      'hi': '',
    },
    'luzu9ah7': {
      'en': 'Padel',
      'hi': '',
    },
    'tj81zx5p': {
      'en': 'Badminton',
      'hi': '',
    },
    'kdtj6nud': {
      'en': 'Nearest Venue',
      'hi': '',
    },
    '85zrq3az': {
      'en': 'Click to change',
      'hi': '',
    },
    '0vcbxibm': {
      'en': '',
      'hi': '',
    },
    'iebkzode': {
      'en': '',
      'hi': '',
    },
    '7fbwh8aw': {
      'en': 'Home',
      'hi': '',
    },
  },
  // findPlayersNew
  {
    '8xi68bcp': {
      'en': 'Home',
      'hi': '',
    },
  },
  // chatsnew
  {
    '9tkforqk': {
      'en': 'Chats',
      'hi': '',
    },
    'beiefidb': {
      'en': 'TextField',
      'hi': '',
    },
    'arazdo5g': {
      'en': 'Badminton',
      'hi': '',
    },
    'vc02kv5u': {
      'en': 'Pickleball',
      'hi': '',
    },
    '8u99q7v2': {
      'en': 'Padel',
      'hi': '',
    },
    'a583krnu': {
      'en': 'Badminton',
      'hi': '',
    },
    '8xdc2mu3': {
      'en': 'Gurgaon Badminton Club',
      'hi': '',
    },
    'usbqh8in': {
      'en': 'Level 3',
      'hi': '',
    },
    'xy9f8iy8': {
      'en': 'Home',
      'hi': '',
    },
  },
  // playerNew
  {
    'xjsu641q': {
      'en': 'Profile Dashboard',
      'hi': '',
    },
    'bdhy309w': {
      'en': 'Profile',
      'hi': '',
    },
    'bii7r7bs': {
      'en': 'Personal Info',
      'hi': '',
    },
    'ngjro2fl': {
      'en': 'Edit Profile',
      'hi': '',
    },
    'g7c98s0p': {
      'en': 'Your Information',
      'hi': '',
    },
    'mxwts58t': {
      'en': 'Fill in your details below to continue',
      'hi': '',
    },
    '36w778kt': {
      'en': 'Name',
      'hi': '',
    },
    'lwg94e5w': {
      'en': 'Rishabh',
      'hi': '',
    },
    '4zwiw7ym': {
      'en': 'Email',
      'hi': '',
    },
    'mgw70gbm': {
      'en': 'robert@gmail.com',
      'hi': '',
    },
    'ms9xetcx': {
      'en': 'Complete Profile',
      'hi': '',
    },
    'u0i0dver': {
      'en': 'First Name',
      'hi': '',
    },
    'amvvqfv7': {
      'en': 'Location',
      'hi': '',
    },
    'dkeucgb0': {
      'en': 'User Set Level',
      'hi': '',
    },
    'utocupip': {
      'en': 'Achievement Tags',
      'hi': '',
    },
    'jqz5tkyd': {
      'en': 'Recognition earned through gameplay',
      'hi': '',
    },
    '9ve2d42w': {
      'en': 'My Games',
      'hi': '',
    },
    'gnxkz4tj': {
      'en': 'Game History',
      'hi': '',
    },
    'y9591ufb': {
      'en': 'Your recent gaming activity',
      'hi': '',
    },
    '9lfarbwe': {
      'en': 'Home',
      'hi': '',
    },
  },
  // GameRequestsnew
  {
    '32gjfr9j': {
      'en': 'Game Requests',
      'hi': '',
    },
    'cwyrad9y': {
      'en': 'Players who request game will appear here',
      'hi': '',
    },
    'ajy3n41x': {
      'en': 'Invited you to play',
      'hi': '',
    },
    'yqvc7rtj': {
      'en': 'Date',
      'hi': '',
    },
    '0gdtopy1': {
      'en': 'Time',
      'hi': '',
    },
    'yl0avxd6': {
      'en': '9:00 PM',
      'hi': '',
    },
    'ijf5q92f': {
      'en': 'Home',
      'hi': '',
    },
  },
  // Duorequestsnew
  {
    '6e1oxs3a': {
      'en': 'Duos',
      'hi': '',
    },
    'b8pl1rrl': {
      'en': '1 pending invitations',
      'hi': '',
    },
    'tzlyjua8': {
      'en': 'Your playing partners will appear here',
      'hi': '',
    },
    'ax5sh3tl': {
      'en': 'Vivek',
      'hi': '',
    },
    'rzsybk6t': {
      'en': 'reqeusted',
      'hi': '',
    },
    'vadox1h5': {
      'en': '84d ago',
      'hi': '',
    },
    'n602zbrk': {
      'en': 'Vivek',
      'hi': '',
    },
    'eaq8cp5c': {
      'en': 'pending',
      'hi': '',
    },
    'sn0xuv9q': {
      'en': '84d ago',
      'hi': '',
    },
    '0w2fjucs': {
      'en': 'Accept',
      'hi': '',
    },
    'oflgxh9r': {
      'en': 'Home',
      'hi': '',
    },
  },
  // LoginNew
  {
    'kfoz44rt': {
      'en': 'Login',
      'hi': '',
    },
    'cmvw3dtv': {
      'en': 'Enter your number',
      'hi': '',
    },
    '80w9x90m': {
      'en': 'Not registered? Go to signup',
      'hi': '',
    },
    'mkljq6oa': {
      'en': 'Mobile Number',
      'hi': '',
    },
    '368djzs3': {
      'en': '9999999999',
      'hi': '',
    },
    'uvuufyiu': {
      'en': 'Mobile Number is required',
      'hi': '',
    },
    '3z7v73w6': {
      'en': 'Enter complete mobile number',
      'hi': '',
    },
    'b1544qii': {
      'en': 'Please choose an option from the dropdown',
      'hi': '',
    },
    'js84r75l': {
      'en': 'Login',
      'hi': '',
    },
    'gjjk4mg2': {
      'en': 'Home',
      'hi': '',
    },
  },
  // rsvpfreeticketsaver
  {
    'enih5alf': {
      'en': 'Ticket name',
      'hi': '',
    },
    'xnr82515': {
      'en': 'Capacity',
      'hi': '',
    },
    '6u1b64cd': {
      'en': 'Description / Additional info',
      'hi': '',
    },
    '27gplpqv': {
      'en': 'Save',
      'hi': '',
    },
    'ku6j6fx4': {
      'en': 'Close',
      'hi': '',
    },
  },
  // paidticketsaver
  {
    'j41th9b2': {
      'en': 'Ticket name',
      'hi': '',
    },
    'zqdhqt8q': {
      'en': 'Single ticket',
      'hi': '',
    },
    'mr8ked03': {
      'en': 'Please select...',
      'hi': '',
    },
    '1aijpdeg': {
      'en': 'Search for an item...',
      'hi': '',
    },
    'dmq18ja9': {
      'en': 'Single ticket',
      'hi': '',
    },
    'e6retl5d': {
      'en': 'Group ticket',
      'hi': '',
    },
    'cqwoyuxf': {
      'en': '2',
      'hi': '',
    },
    'v2y32iub': {
      'en': 'Ticket per group',
      'hi': '',
    },
    '927m0d88': {
      'en': 'Search for an item...',
      'hi': '',
    },
    '0hiziuli': {
      'en': '2',
      'hi': '',
    },
    'qlwh78ef': {
      'en': '3',
      'hi': '',
    },
    'zupzsekn': {
      'en': '4',
      'hi': '',
    },
    '1nfapxiv': {
      'en': '5',
      'hi': '',
    },
    'zlm69hot': {
      'en': '6',
      'hi': '',
    },
    'l437ss8u': {
      'en': 'Capacity',
      'hi': '',
    },
    'ctsy1qd3': {
      'en': 'Price',
      'hi': '',
    },
    '7wcpufyz': {
      'en': '₹',
      'hi': '',
    },
    'and07284': {
      'en': 'Price should be under ₹500',
      'hi': '',
    },
    'zqvmlxzy': {
      'en': 'Description / Additional info',
      'hi': '',
    },
    'w65095l0': {
      'en': 'Save',
      'hi': '',
    },
    'stk18u8p': {
      'en': 'Close',
      'hi': '',
    },
  },
  // seeintrestedpeople
  {
    'dpn98hz8': {
      'en': 'View Profile',
      'hi': '',
    },
    '2ak4uv1d': {
      'en': 'Close',
      'hi': '',
    },
  },
  // flagblockuser
  {
    '4yfp2q1t': {
      'en': 'Flag as inappropriate',
      'hi': '',
    },
    'sb05c7m5': {
      'en': 'Block user',
      'hi': '',
    },
    '980i6coj': {
      'en': 'Cancel',
      'hi': '',
    },
  },
  // navbar
  {
    'z1e1yfj5': {
      'en': 'Home',
      'hi': '',
    },
    'zp3f3xz7': {
      'en': 'Search',
      'hi': '',
    },
    'e3h6hlbx': {
      'en': 'Analytics',
      'hi': '',
    },
    'lkhelj0f': {
      'en': 'History',
      'hi': '',
    },
  },
  // navbarnew
  {
    '1hq3c6xy': {
      'en': 'Home',
      'hi': '',
    },
    's3tvmbjo': {
      'en': 'Venues',
      'hi': '',
    },
    'tnff4dct': {
      'en': 'Games',
      'hi': '',
    },
    'lf9fz21z': {
      'en': 'More',
      'hi': '',
    },
  },
  // getlevelcomponent
  {
    'uole6xjs': {
      'en': 'Choose level',
      'hi': '',
    },
    'f4hrj7dr': {
      'en': 'Select your playing level to continue.',
      'hi': '',
    },
    '7of30krr': {
      'en': 'Level 1',
      'hi': '',
    },
    'bdchr1b2': {
      'en': 'Level 2',
      'hi': '',
    },
    'v1nk58bw': {
      'en': 'Level 3',
      'hi': '',
    },
    '7b3ky182': {
      'en': 'Level 4',
      'hi': '',
    },
    'ptyra33h': {
      'en': 'Cancel',
      'hi': '',
    },
  },
  // AllAvailableVenues
  {
    '8uwf26uf': {
      'en': 'Nearest Venue',
      'hi': '',
    },
  },
  // Miscellaneous
  {
    'kt2qo58f': {
      'en': 'In order to make games more memorable, we take pictures',
      'hi': '',
    },
    'ab5j6r5p': {
      'en': 'Upload good images to increase your profile visibility',
      'hi': '',
    },
    'fdyhxotc': {
      'en': 'We need your location to show nearby venues',
      'hi': '',
    },
    'tqngxetj': {
      'en': 'Lets update your location',
      'hi': '',
    },
    '1jzpdkse': {
      'en': '',
      'hi': '',
    },
    '4pzp98qa': {
      'en': '',
      'hi': '',
    },
    '2xgcdo0k': {
      'en': '',
      'hi': '',
    },
    '9x7tnfp8': {
      'en': '',
      'hi': '',
    },
    '47wyeguy': {
      'en': '',
      'hi': '',
    },
    'cay5qfcc': {
      'en': '',
      'hi': '',
    },
    '5aip84uy': {
      'en': '',
      'hi': '',
    },
    'jlavsdbw': {
      'en': '',
      'hi': '',
    },
    'd85n82zh': {
      'en': '',
      'hi': '',
    },
    'nqwnhpw7': {
      'en': '',
      'hi': '',
    },
    'dzd8e4y1': {
      'en': '',
      'hi': '',
    },
    'p4dizztq': {
      'en': '',
      'hi': '',
    },
    '1lowcz2l': {
      'en': '',
      'hi': '',
    },
    '6yo5iib3': {
      'en': '',
      'hi': '',
    },
    '0vdkoglk': {
      'en': '',
      'hi': '',
    },
    'kuendohk': {
      'en': '',
      'hi': '',
    },
    'h9j37v9b': {
      'en': '',
      'hi': '',
    },
    'zp7k5jdj': {
      'en': '',
      'hi': '',
    },
    '7wanekiq': {
      'en': '',
      'hi': '',
    },
    'h9h3rxnz': {
      'en': '',
      'hi': '',
    },
    'v9cz4ua3': {
      'en': '',
      'hi': '',
    },
    'aj0bbqso': {
      'en': '',
      'hi': '',
    },
    'u4zb7ih1': {
      'en': '',
      'hi': '',
    },
    'mijjvycz': {
      'en': '',
      'hi': '',
    },
    'uxldbs1k': {
      'en': '',
      'hi': '',
    },
  },
].reduce((a, b) => a..addAll(b));
