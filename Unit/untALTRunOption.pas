unit untALTRunOption;

interface
uses
  Windows,
  IniFiles,
  Classes,
  SysUtils,
  Graphics,
  Forms,
  HotKeyManager,
  untUtilities,
  untLogger;

const
  DEBUG_MODE = False;
  DEBUG_SORT = False;

  //TITLE = 'HotRun';
  //VERSION = 'V0.96';
  TITLE = 'ALTRun';
  ALTRUN_VERSION = 'V1.46.7';
  //第1贴 http://journeyboy.blog.sohu.com/79386735.html 已经超过40K字数;
  //第2贴 http://journeyboy.blog.sohu.com/93455878.html 已经超过40K字数;
  UPGRADE_URL = 'http://journeyboy.blog.sohu.com/112820379.html';

  PARAM_FLAG = '%p';
  NEW_PARAM_FLAG = '{%p}';
  CLIPBOARD_FLAG = '{%c}';
  FOREGROUND_WINDOW_ID_FLAG = '{%wd}';
  FOREGROUND_WINDOW_TEXT_FLAG = '{%wt}';
  FOREGROUND_WINDOW_CLASS_FLAG = '{%wc}';
  SHOW_MAX_FLAG='@+';
  SHOW_MIN_FLAG='@-';
  SHOW_HIDE_FLAG='@';

  RESTART_FLAG = 'Restart';
  CLEAN_FLAG = 'Clean';
  CMD_DIR = 'MyCmd';
  LOCALIZED_KEYNAMES = True;

  SECTION_CONFIG = 'Config';
  SECTION_WINDOW = 'Window';
  SECTION_GUI = 'GUI';
  SECTION_DEBUG = 'DEBUG';

  KEY_HOTKEY1 = 'HotKey1';
  KEY_HOTKEY2 = 'HotKey2';
  KEY_LASTITEMHOTKEY = 'LastItemHotKey';
  KEY_AUTORUN = 'AutoRun';
  KEY_ADDTOSENDTO = 'AddToSendTo';
  KEY_REGEX = 'Regex';
  KEY_HIDEDELAY = 'HideDelay';
  KEY_MATCHANYWHERE = 'MatchAnywhere';
  KEY_NUMBERKEY = 'NumberKey';
  KEY_INDEXFROM0TO9 = 'IndexFrom0to9';
  KEY_REMEMBERFAVOURATMATCH = 'RememberFavouratMatch';
  KEY_PARAMHISTORYLIMIT = 'ParamHistoryLimit';
  KEY_SHOWOPERATIONHINT = 'ShowOperationHint';
  KEY_SHOWCOMMANDLINE = 'ShowCommandLine';
  KEY_SHOWSTARTNOTIFICATION = 'ShowStartNotification';
  KEY_SHOWTOPTEN = 'ShowTopTen';
  KEY_PLAYPOPUPNOTIFY = 'PlayPopupNotify';
  KEY_EXITWHENEXECUTE = 'ExitWhenExecute';
  KEY_SHOWSKIN = 'ShowSkin';
  KEY_SHOWMEWHENSTART = 'ShowMeWhenStart';
  KEY_SHOWTRAYICON = 'ShowTrayIcon';
  KEY_SHOWSHORTCUTBUTTON = 'ShowShortCutButton';
  KEY_SHOWCONFIGBUTTON = 'ShowConfigButton';
  KEY_SHOWCLOSEBUTTON = 'ShowCloseButton';
  KEY_EXECUTEIFONLYONE = 'ExecuteIfOnlyOne';

  KEY_WINTOP = 'WinTop';
  KEY_WINLEFT = 'WinLeft';
  KEY_MANWINTOP = 'ManWinTop';
  KEY_MANWINLEFT = 'ManWinLeft';
  KEY_MANWINWIDTH = 'ManWinWidth';
  KEY_MANWINHEIGHT = 'ManWinHeight';
  KEY_MANCOLWIDTH = 'ManColWidth';

  KEY_BGFILENAME = 'BGFileName';
  KEY_TITLECOLOR = 'TitleColor';
  KEY_KEYWORDCOLOR = 'KeywordColor';
  KEY_LISTCOLOR = 'ListColor';
  KEY_TITLEFONT = 'TitleFont';
  KEY_KEYWORDFONT = 'KeywordFont';
  KEY_LISTFONT = 'ListFont';
  KEY_LISTFORMAT = 'ListFormat';

  KEY_ALPHACOLOR = 'AlphaColor';
  KEY_ALPHA = 'Alpha';
  KEY_ROUNDBORDERRADIUS = 'RoundBorderRadius';
  KEY_FORMWIDTH = 'FormWidth';
  KEY_LANG = 'Lang';

  DEFAULT_TITLE_FONT_STR = '宋体|[]|12|65535|0';
  DEFAULT_KEYWORD_FONT_STR = '宋体|[]|12|255|0';
  DEFAULT_LIST_FONT_STR = '宋体|[]|12|8388608|0';
  DEFAULT_LIST_FORMAT = '%-25s| %s';
  DEFAULT_ALPHACOLOR = clBlack;
  DEFAULT_ALPHA = 240;
  DEFAULT_ROUNDBORDERRADIUS = 12;
  DEFAULT_FORMWIDTH = 420;
  DEFAULT_BGFILENAME = 'BG.jpg';
  DEFAULT_LANG = 'EN';

  KEY_TRACEENABLE = 'TraceEnable';
  KEY_SHORTCUTRUNCOUNT = 'ShortCutRunCount';
  KEY_HANDLEID = 'HandleID';
  KEY_MODIFYTIME = 'ModifyTime';
  KEY_LATESTLIST = 'LatestList';

  //--------------------
  //语言配置
  //--------------------
  SECTION_COMMON = 'Common';
  SECTION_ALTRUNFORM = 'ALTRunForm';
  SECTION_CONFIGFORM = 'ConfigForm';
  SECTION_INVALIDFORM = 'InvalidForm';
  SECTION_SHORTCUTMANFORM = 'ShortCutManForm';
  SECTION_SHORTCUTFORM = 'ShortCutForm';
  SECTION_ABOUTFORM = 'AboutForm';
  SECTION_DEFAULTSHORTCUTLIST = 'DefaultShortCutName';

  //Common
  KEY_INFO = 'Info';
  KEY_ABOUT = 'About';
  KEY_DELETE = 'Delete';
  KEY_WARNING = 'Warning';
  KEY_WORDOR = 'WordOr';
  KEY_WORDAND = 'WordAnd';

  KEY_MENUSHOW = 'MenuShow';
  KEY_MENUSHORTCUT = 'MenuShortCut';
  KEY_MENUCONFIG = 'MenuConfig';
  KEY_MENUABOUT = 'MenuAbout';
  KEY_MENUCLOSE = 'MenuClose';

  KEY_BTNOK = 'BtnOK';
  KEY_BTNCANCEL = 'BtnCancel';
  KEY_BTNRESET = 'BtnReset';
  KEY_BTNHELP = 'BtnHelp';
  KEY_BTNTEST = 'BtnTest';
  KEY_BTNADD = 'BtnAdd';
  KEY_BTNEDIT = 'BtnEdit';
  KEY_BTNDELETE = 'BtnDelete';
  KEY_BTNPATHCONVERT = 'BtnPathConvert';
  KEY_BTNVALIDATE = 'BtnValidate';
  KEY_BTNCLOSE = 'BtnClose';

  KEY_SHORTCUT = 'ShortCut';
  KEY_NAME = 'Name';
  KEY_PARAMTYPE = 'ParamType';
  KEY_COMMANDLINE = 'CommandLine';
  KEY_CANNOTEXECUTE = 'CanNotExecute';

  //ALTRunForm
  KEY_STARTED = 'Started';
  KEY_PRESSKEYTOSHOWME = 'PressKeyToShowMe';
  KEY_MAINHINT = 'MainHint';
  KEY_SHOWMEBYHOTKEY = 'ShowMeByHotKey';
  KEY_NOITEMANDADD = 'NoItemAndAdd';
  KEY_HOTKEYERROR = 'HotKeyError';
  KEY_CMDLINE = 'CMDLine';
  KEY_RUNNUM = 'RunNum';
  KEY_KEYTOADD = 'KeyToAdd';
  KEY_KEYTOOPENFOLDER = 'KeyToOpenFolder';
  KEY_KEYTORUN = 'KeyToRun';
  KEY_AUTORUNWHENSTART = 'AutoRunWhenStart';
  KEY_ADDTOSENDTOMENU = 'AddToSendToMenu';
  KEY_RESTARTMEINFO = 'RestartMeInfo';
  KEY_CLEANCONFIRM = 'CleanConfirm';
  KEY_RELATIVEPATHSUGGESTION = 'RelativePathSuggestion';
  KEY_GETFILENAMEFAIL = 'GetFileNameFail';
  KEY_SHORTCUTEXISTED = 'ShortCutExisted';
  KEY_CONGRATULATIONS = 'Congratulations';
  KEY_BLANKLINEADDED = 'BlankLineAdded';

  KEY_BTNSHORTCUTHINT = 'BtnShortCutHint';
  KEY_BTNCONFIGHINT = 'BtnConfigHint';
  KEY_BTNFAKECLOSEHINT = 'BtnFAKECloseHint';
  KEY_EDTSHORTCUTHINT = 'EdtShortCutHint';

  KEY_HINTLIST_0 = 'HintList_0';
  KEY_HINTLIST_1 = 'HintList_1';
  KEY_HINTLIST_2 = 'HintList_2';
  KEY_HINTLIST_3 = 'HintList_3';
  KEY_HINTLIST_4 = 'HintList_4';
  KEY_HINTLIST_5 = 'HintList_5';
  KEY_HINTLIST_6 = 'HintList_6';
  KEY_HINTLIST_7 = 'HintList_7';
  KEY_HINTLIST_8 = 'HintList_8';
  KEY_HINTLIST_9 = 'HintList_9';
  KEY_HINTLIST_10 = 'HintList_10';
  KEY_HINTLIST_11 = 'HintList_11';
  KEY_HINTLIST_12 = 'HintList_12';
  KEY_HINTLIST_13 = 'HintList_13';
  KEY_HINTLIST_14 = 'HintList_14';
  KEY_HINTLIST_15 = 'HintList_15';
  KEY_HINTLIST_16 = 'HintList_16';
  KEY_HINTLIST_17 = 'HintList_17';
  KEY_HINTLIST_18 = 'HintList_18';
  KEY_HINTLIST_19 = 'HintList_19';
  KEY_HINTLIST_20 = 'HintList_20';
  KEY_HINTLIST_21 = 'HintList_21';
  KEY_HINTLIST_22 = 'HintList_22';
  KEY_HINTLIST_23 = 'HintList_23';
  KEY_HINTLIST_24 = 'HintList_24';

  //ConfigForm
  KEY_PAGECONFIG = 'PageConfig';
  KEY_PAGEHOTKEY = 'PageHotKey';
  KEY_PAGEFONT = 'PageFont';
  KEY_PAGEFORM = 'PageForm';
  KEY_PAGELANG = 'PageLang';

  KEY_CONFIGFORMCAPTION = 'ConfigFormCaption';
  KEY_RESETALLCONFIG = 'ResetAllConfig';
  KEY_RESETALLFONTS = 'ResetAllFonts';
  KEY_VOIDHOTKEY = 'VoidHotKey';

  KEY_LBLHOTKEY1 = 'LblHotKey1';
  KEY_LBLHOTKEY2 = 'LblHotKey2';
  KEY_LBLTITLEFONT = 'LblTitleFont';
  KEY_LBLTITLESAMPLE = 'LblTitleSample';
  KEY_LBLKEYWORDFONT = 'LblKeywordFont';
  KEY_LBLKEYWORDSAMPLE = 'LblKeywordSample';
  KEY_LBLLISTFONT = 'LblListFont';
  KEY_LBLLISTSAMPLE = 'LblListSample';
  KEY_LBLLISTFORMAT = 'LblListFormat';
  KEY_LBLRESETFONT = 'LblResetFont';
  KEY_LBLFORMATSAMPLE = 'LblFormatSample';
  KEY_LBLLISTFORMATSAMPLE = 'LblListFormatSample';
  KEY_LBLFORMALPHACOLOR = 'LblFormAlphaColor';
  KEY_LBLFORMALPHA = 'LblFormAlpha';
  KEY_LBLROUNDBORDERRADIUS = 'LblRoundBorderRadius';
  KEY_LBLFORMWIDTH = 'LblFormWidth';
  KEY_LBLBACKGROUNDIMAGE = 'LblBackGroundImage';
  KEY_LBLALPHAHINT = 'LblAlphaHint';
  KEY_LBLLANGUAGE = 'LblLanguage';
  KEY_LBLLANGUAGEHINT = 'LblLanguageHint';
  KEY_LBLHOTKEYHINT = 'LblHotKeyHint';
  KEY_LBLHOTKEYHINT1 = 'LblHotKeyHint1';
  KEY_LBLHOTKEYHINT2 = 'LblHotKeyHint2';

  KEY_BTNMODIFYTITLEFONT = 'BtnModifyTitleFont';
  KEY_BTNMODIFYKEYWORDFONT = 'BtnModifyKeywordFont';
  KEY_BTNMODIFYLISTFONT = 'BtnModifyListFont';
  KEY_BTNRESETALLFONTS = 'BtnResetAllFonts';

  KEY_CONFIGLIST_0 = 'ConfigList_0';
  KEY_CONFIGLIST_1 = 'ConfigList_1';
  KEY_CONFIGLIST_2 = 'ConfigList_2';
  KEY_CONFIGLIST_3 = 'ConfigList_3';
  KEY_CONFIGLIST_4 = 'ConfigList_4';
  KEY_CONFIGLIST_5 = 'ConfigList_5';
  KEY_CONFIGLIST_6 = 'ConfigList_6';
  KEY_CONFIGLIST_7 = 'ConfigList_7';
  KEY_CONFIGLIST_8 = 'ConfigList_8';
  KEY_CONFIGLIST_9 = 'ConfigList_9';
  KEY_CONFIGLIST_10 = 'ConfigList_10';
  KEY_CONFIGLIST_11 = 'ConfigList_11';
  KEY_CONFIGLIST_12 = 'ConfigList_12';
  KEY_CONFIGLIST_13 = 'ConfigList_13';
  KEY_CONFIGLIST_14 = 'ConfigList_14';
  KEY_CONFIGLIST_15 = 'ConfigList_15';
  KEY_CONFIGLIST_16 = 'ConfigList_16';
  KEY_CONFIGLIST_17 = 'ConfigList_17';
  KEY_CONFIGLIST_18 = 'ConfigList_18';
  KEY_CONFIGLIST_19 = 'ConfigList_19';

  KEY_CONFIGDESCLIST_0 = 'ConfigDescList_0';
  KEY_CONFIGDESCLIST_1 = 'ConfigDescList_1';
  KEY_CONFIGDESCLIST_2 = 'ConfigDescList_2';
  KEY_CONFIGDESCLIST_3 = 'ConfigDescList_3';
  KEY_CONFIGDESCLIST_4 = 'ConfigDescList_4';
  KEY_CONFIGDESCLIST_5 = 'ConfigDescList_5';
  KEY_CONFIGDESCLIST_6 = 'ConfigDescList_6';
  KEY_CONFIGDESCLIST_7 = 'ConfigDescList_7';
  KEY_CONFIGDESCLIST_8 = 'ConfigDescList_8';
  KEY_CONFIGDESCLIST_9 = 'ConfigDescList_9';
  KEY_CONFIGDESCLIST_10 = 'ConfigDescList_10';
  KEY_CONFIGDESCLIST_11 = 'ConfigDescList_11';
  KEY_CONFIGDESCLIST_12 = 'ConfigDescList_12';
  KEY_CONFIGDESCLIST_13 = 'ConfigDescList_13';
  KEY_CONFIGDESCLIST_14 = 'ConfigDescList_14';
  KEY_CONFIGDESCLIST_15 = 'ConfigDescList_15';
  KEY_CONFIGDESCLIST_16 = 'ConfigDescList_16';
  KEY_CONFIGDESCLIST_17 = 'ConfigDescList_17';
  KEY_CONFIGDESCLIST_18 = 'ConfigDescList_18';
  KEY_CONFIGDESCLIST_19 = 'ConfigDescList_19';

  //InvalidForm
  KEY_INVALIDFORMCAPTION = 'InvalidFormCaption';
  KEY_COMMANDLINEEMPTY = 'CommandLineEempty';

  //ShortCutManForm
  KEY_SHORTCUTMANFORMCAPTION = 'ShortCutManFormCaption';
  KEY_NOINVALIDSHORTCUT = 'NoInvalidShortCut';
  KEY_DELETEBLANKLINET = 'DeleteBlankLine';
  KEY_DELETECONFIRM = 'DeleteConfirm';
  KEY_VALIDATECONFIRM = 'ValidateConfirm';
  KEY_PATHCONVERTCONFIRM = 'PathConvertConfirm';
  KEY_CONVERTFINISHED = 'ConvertFinished';

  KEY_BTNADDHINT = 'BtnAddHint';
  KEY_BTNEDITHINT = 'BtnEditHint';
  KEY_BTNDELETEHINT = 'BtnDeleteHint';
  KEY_BtnPathConvertHint = 'BtnPathConvertHint';
  KEY_BTNVALIDATEHINT = 'BtnValidateHint';
  KEY_BTNHELPHINT = 'BtnHelpHint';
  KEY_BTNCLOSEHINT = 'BtnCloseHint';
  KEY_BTNCANCELHINT = 'BtnCancelHint';

  //ShortCutForm
  KEY_SHORTCUTFORMCAPTION = 'ShortCutFormCaption';
  KEY_GRPSHORTCUT = 'GrpShortCut';
  KEY_BTNFILE = 'BtnFile';
  KEY_BTNDIR = 'BtnDir';
  KEY_GRPPARAMTYPE = 'GrpParamType';
  KEY_LBLEDTCOMMANDLINEHINT = 'LblEdtCommandLineHint';
  KEY_PARAMTYPE_0 = 'ParamType_0';
  KEY_PARAMTYPE_1 = 'ParamType_1';
  KEY_PARAMTYPE_2 = 'ParamType_2';
  KEY_PARAMTYPE_3 = 'ParamType_3';

  KEY_SELECTDIR = 'SelectDir';
  KEY_PARAMCONFIRM = 'ParamConfirm';
  KEY_REPLACECONFIRM = 'ReplaceConfirm';
  KEY_REPLACESHORTCUTCONFIRM = 'ReplaceShortCutConfirm';
  KEY_REPLACENAMECONFIRM = 'ReplaceNameConfirm';
  KEY_NAMECANNOTINCLUDE = 'NameCanNotInclude';

  //AboutForm
  KEY_STATISTICS = 'Statistics';

  //Default ShortCut List
  KEY_DEFAULTSHORTCUTLIST_0 = 'Default_ShortCut_Name_0';
  KEY_DEFAULTSHORTCUTLIST_1 = 'Default_ShortCut_Name_1';
  KEY_DEFAULTSHORTCUTLIST_2 = 'Default_ShortCut_Name_2';
  KEY_DEFAULTSHORTCUTLIST_3 = 'Default_ShortCut_Name_3';
  KEY_DEFAULTSHORTCUTLIST_4 = 'Default_ShortCut_Name_4';
  KEY_DEFAULTSHORTCUTLIST_5 = 'Default_ShortCut_Name_5';
  KEY_DEFAULTSHORTCUTLIST_6 = 'Default_ShortCut_Name_6';
  KEY_DEFAULTSHORTCUTLIST_7 = 'Default_ShortCut_Name_7';
  KEY_DEFAULTSHORTCUTLIST_8 = 'Default_ShortCut_Name_8';
  KEY_DEFAULTSHORTCUTLIST_9 = 'Default_ShortCut_Name_9';
  KEY_DEFAULTSHORTCUTLIST_10 = 'Default_ShortCut_Name_10';
  KEY_DEFAULTSHORTCUTLIST_11 = 'Default_ShortCut_Name_11';
  KEY_DEFAULTSHORTCUTLIST_12 = 'Default_ShortCut_Name_12';
  KEY_DEFAULTSHORTCUTLIST_13 = 'Default_ShortCut_Name_13';
  KEY_DEFAULTSHORTCUTLIST_14 = 'Default_ShortCut_Name_14';
  KEY_DEFAULTSHORTCUTLIST_15 = 'Default_ShortCut_Name_15';
  KEY_DEFAULTSHORTCUTLIST_16 = 'Default_ShortCut_Name_16';
  KEY_DEFAULTSHORTCUTLIST_17 = 'Default_ShortCut_Name_17';
  KEY_DEFAULTSHORTCUTLIST_18 = 'Default_ShortCut_Name_18';
  KEY_DEFAULTSHORTCUTLIST_19 = 'Default_ShortCut_Name_19';
  KEY_DEFAULTSHORTCUTLIST_20 = 'Default_ShortCut_Name_20';
  KEY_DEFAULTSHORTCUTLIST_21 = 'Default_ShortCut_Name_21';
  KEY_DEFAULTSHORTCUTLIST_22 = 'Default_ShortCut_Name_22';
  KEY_DEFAULTSHORTCUTLIST_23 = 'Default_ShortCut_Name_23';
  KEY_DEFAULTSHORTCUTLIST_24 = 'Default_ShortCut_Name_24';
  KEY_DEFAULTSHORTCUTLIST_25 = 'Default_ShortCut_Name_25';
  KEY_DEFAULTSHORTCUTLIST_26 = 'Default_ShortCut_Name_26';
  KEY_DEFAULTSHORTCUTLIST_27 = 'Default_ShortCut_Name_27';
  KEY_DEFAULTSHORTCUTLIST_28 = 'Default_ShortCut_Name_28';
  KEY_DEFAULTSHORTCUTLIST_29 = 'Default_ShortCut_Name_29';
  KEY_DEFAULTSHORTCUTLIST_30 = 'Default_ShortCut_Name_30';
  KEY_DEFAULTSHORTCUTLIST_31 = 'Default_ShortCut_Name_31';
  KEY_DEFAULTSHORTCUTLIST_32 = 'Default_ShortCut_Name_32';
  KEY_DEFAULTSHORTCUTLIST_33 = 'Default_ShortCut_Name_33';
  KEY_DEFAULTSHORTCUTLIST_34 = 'Default_ShortCut_Name_34';
  KEY_DEFAULTSHORTCUTLIST_35 = 'Default_ShortCut_Name_35';
  KEY_DEFAULTSHORTCUTLIST_36 = 'Default_ShortCut_Name_36';
  KEY_DEFAULTSHORTCUTLIST_37 = 'Default_ShortCut_Name_37';
  
var
  HotKeyStr1: string;
  HotKeyStr2: string;
  LastItemHotKeyStr: string;
  TraceEnable: Boolean;
  IsRunFirstTime: Boolean;

  AutoRun: Boolean;
  AddToSendTo: Boolean;
  EnableRegex: Boolean;
  HideDelay: Integer;
  MatchAnywhere: Boolean;
  EnableNumberKey: Boolean;
  IndexFrom0to9: Boolean;
  RememberFavouratMatch: Boolean;
  ParamHistoryLimit: Integer;
  ShowOperationHint: Boolean;
  ShowCommandLine: Boolean;
  ShowStartNotification: Boolean;
  ShowTopTen: Boolean;
  PlayPopupNotify: Boolean;
  ExitWhenExecute: Boolean;
  ShowSkin: Boolean;
  ShowMeWhenStart: Boolean;
  ShowTrayIcon: Boolean;
  ShowShortCutButton: Boolean;
  ShowConfigButton: Boolean;
  ShowCloseButton: Boolean;
  ExecuteIfOnlyOne: Boolean;

  BGFileName: string;
  TitleColor: TColor;
  KeywordColor: TColor;
  ListColor: TColor;
  TitleFontStr: string;
  KeywordFontStr: string;
  ListFontStr: string;
  ListFormat: string;
  AlphaColor: TColor;
  Alpha: Integer;
  RoundBorderRadius: Integer;
  FormWidth: Integer;
  Lang: string;

  WinTop, WinLeft: Integer;
  ManWinTop, ManWinLeft, ManWinWidth, ManWinHeight: Integer;
  ManColWidth: array[0..3] of Integer;

  ShortCutRunCount: Integer;
  HandleID: Cardinal;
  ModifyTime: string;
  LatestList: string;

  //--------------------
  //资源配置
  //--------------------

  //Common
  resInfo: string;
  resAbout: string;
  resDelete: string;
  resWarning: string;
  resWordOr: string;
  resWordAnd: string;

  resMenuShow: string;
  resMenuShortCut: string;
  resMenuConfig: string;
  resMenuAbout: string;
  resMenuClose: string;

  resBtnOK: string;
  resBtnCancel: string;
  resBtnReset: string;
  resBtnHelp: string;
  resBtnTest: string;
  resBtnAdd: string;
  resBtnEdit: string;
  resBtnDelete: string;
  resBtnPathConvert: string;
  resBtnValidate: string;
  resBtnClose: string;

  resShortCut: string;
  resName: string;
  resParamType: string;
  resCommandLine: string;
  resCanNotExecute: string;

  //ALTRunForm
  resStarted: string;
  resPressKeyToShowMe: string;
  resMainHint: string;
  resShowMeByHotKey: string;
  resNoItemAndAdd: string;
  resHotKeyError: string;
  resCMDLine: string;
  resRunNum: string;
  resKeyToAdd: string;
  resKeyToOpenFolder: string;
  resKeyToRun: string;
  resAutoRunWhenStart: string;
  resAddToSendToMenu: string;
  resRestartMeInfo: string;
  resCleanConfirm: string;
  resRelativePathSuggestion: string;
  resGetFileNameFail: string;
  resShortCutExisted: string;
  resCongratulations: string;
  resBlankLineAdded: string;

  resBtnShortCutHint: string;
  resBtnConfigHint: string;
  resBtnFakeCloseHint: string;
  resEdtShortCutHint: string;

  //ConfigForm
  resPageConfig: string;
  resPageHotKey: string;
  resPageFont: string;
  resPageForm: string;
  resPageLang: string;

  resConfigFormCaption: string;
  resResetAllConfig: string;
  resResetAllFonts: string;
  resVoidHotKey: string;

  resLblHotKey1: string;
  resLblHotKey2: string;
  resLblTitleFont: string;
  resLblTitleSample: string;
  resLblKeywordFont: string;
  resLblKeywordSample: string;
  resLblListFont: string;
  resLblListSample: string;
  resLblListFormat: string;
  resLblResetFont: string;
  resLblFormatSample: string;
  resLblListFormatSample: string;
  resLblFormAlphaColor: string;
  resLblFormAlpha: string;
  resLblRoundBorderRadius: string;
  resLblFormWidth: string;
  resLblBackGroundImage: string;
  resLblAlphaHint: string;
  resLblLanguage: string;
  resLblLanguageHint: string;
  resLblHotKeyHint: string;
  resLblHotKeyHint1: string;
  resLblHotKeyHint2: string;

  resBtnModifyTitleFont: string;
  resBtnModifyKeywordFont: string;
  resBtnModifyListFont: string;
  resBtnResetAllFonts: string;

  resConfigList_0: string;
  resConfigList_1: string;
  resConfigList_2: string;
  resConfigList_3: string;
  resConfigList_4: string;
  resConfigList_5: string;
  resConfigList_6: string;
  resConfigList_7: string;
  resConfigList_8: string;
  resConfigList_9: string;
  resConfigList_10: string;
  resConfigList_11: string;
  resConfigList_12: string;
  resConfigList_13: string;
  resConfigList_14: string;
  resConfigList_15: string;
  resConfigList_16: string;
  resConfigList_17: string;
  resConfigList_18: string;
  resConfigList_19: string;

  //InvalidForm
  resInvalidFormCaption: string;
  resCommandLineEempty: string;

  //ShortCutManForm
  resShortCutManFormCaption: string;
  resNoInvalidShortCut: string;
  resDeleteBlankLine: string;
  resDeleteConfirm: string;
  resValidateConfirm: string;
  resPathConvertConfirm: string;
  resConvertFinished: string;

  resBtnAddHint: string;
  resBtnEditHint: string;
  resBtnDeleteHint: string;
  resBtnPathConvertHint: string;
  resBtnValidateHint: string;
  resBtnHelpHint: string;
  resBtnCloseHint: string;
  resBtnCancelHint: string;

  //ShortCutForm
  resShortCutFormCaption: string;
  resGrpShortCut: string;
  resBtnFile: string;
  resBtnDir: string;
  resGrpParamType: string;
  resLblEdtCommandLineHint: string;
  resParamType_0: string;
  resParamType_1: string;
  resParamType_2: string;
  resParamType_3: string;

  resSelectDir: string;
  resParamConfirm: string;
  resReplaceConfirm: string;
  resReplaceShortCutConfirm: string;
  resReplaceNameConfirm: string;
  resNameCanNotInclude: string;

  //AboutForm
  resStatistics: string;

  //Default_ShortCut_Name
  resDefault_ShortCut_Name_0: string;
  resDefault_ShortCut_Name_1: string;
  resDefault_ShortCut_Name_2: string;
  resDefault_ShortCut_Name_3: string;
  resDefault_ShortCut_Name_4: string;
  resDefault_ShortCut_Name_5: string;
  resDefault_ShortCut_Name_6: string;
  resDefault_ShortCut_Name_7: string;
  resDefault_ShortCut_Name_8: string;
  resDefault_ShortCut_Name_9: string;
  resDefault_ShortCut_Name_10: string;
  resDefault_ShortCut_Name_11: string;
  resDefault_ShortCut_Name_12: string;
  resDefault_ShortCut_Name_13: string;
  resDefault_ShortCut_Name_14: string;
  resDefault_ShortCut_Name_15: string;
  resDefault_ShortCut_Name_16: string;
  resDefault_ShortCut_Name_17: string;
  resDefault_ShortCut_Name_18: string;
  resDefault_ShortCut_Name_19: string;
  resDefault_ShortCut_Name_20: string;
  resDefault_ShortCut_Name_21: string;
  resDefault_ShortCut_Name_22: string;
  resDefault_ShortCut_Name_23: string;
  resDefault_ShortCut_Name_24: string;
  resDefault_ShortCut_Name_25: string;
  resDefault_ShortCut_Name_26: string;
  resDefault_ShortCut_Name_27: string;
  resDefault_ShortCut_Name_28: string;
  resDefault_ShortCut_Name_29: string;
  resDefault_ShortCut_Name_30: string;
  resDefault_ShortCut_Name_31: string;
  resDefault_ShortCut_Name_32: string;
  resDefault_ShortCut_Name_33: string;
  resDefault_ShortCut_Name_34: string;
  resDefault_ShortCut_Name_35: string;
  resDefault_ShortCut_Name_36: string;
  resDefault_ShortCut_Name_37: string;

  ShortCutListFileName: string;

  HintList: array[0..24] of string { = (
  ('Press INSERT to add new ShortCut'),
  ('Press F2 to rename this ShortCut'),
  ('Press DELETE to delete this ShortCut'),
  ('Press F1 to show About'),
  ('Press ESC to hide me'),
  ('Type "b" to search by Baidu'),
  ('Type "g" to search by Google'),
  ('Type "s" to search MP3 by Sogou'),
  ('Type "zd" to search by Baidu Zhidao'),
  ('Type "y" to search by Yahoo'),
  ('Press CTRL+D to open folder of some ShortCut'),
  ('You can disable this hint in config'),
  ('You can disable the CMD line in config')
  )};

  ConfigDescList: array[0..19] of string;

  ListFormatList: array[0..2] of string = (
    ('%-25s| %s'),
    ('%s (%s)'),
    ('%s [%s]')
    );

procedure LoadSettings;
procedure SaveSettings;
procedure SetActiveLanguage;

function FontStylesToStr(FontStyles: TFontStyles): string;
function StrToFontStyles(strStyles: string): TFontStyles;
function FontToStr(Font: TFont): string;
function StrToFont(strFont: string; Font: TFont): Boolean;

implementation

function FontStylesToStr(FontStyles: TFontStyles): string;
begin
  Result := '';

  if fsBold in FontStyles then Result := Result + ',fsBold';
  if fsItalic in FontStyles then Result := Result + ',fsItalic';
  if fsUnderline in FontStyles then Result := Result + ',fsUnderline';
  if fsStrikeOut in FontStyles then Result := Result + ',fsStrikeOut';

  if Result = '' then
    Result := '['
  else
    Result[1] := '[';

  Result := Result + ']';
end;

function StrToFontStyles(strStyles: string): TFontStyles;
begin
  Result := [];

  if Pos('fsBold', strStyles) > 0 then Result := Result + [fsBold];
  if Pos('fsItalic', strStyles) > 0 then Result := Result + [fsItalic];
  if Pos('fsUnderline', strStyles) > 0 then Result := Result + [fsUnderline];
  if Pos('fsStrikeOut', strStyles) > 0 then Result := Result + [fsStrikeOut];
end;

function FontToStr(Font: TFont): string;
begin
  with Font do
    Result := Format('%s|%s|%d|%d|%d',
      [Name, FontStylesToStr(Style), Size, Color, Charset]);
end;

function StrToFont(strFont: string; Font: TFont): Boolean;
var
  List: TStringList;
begin
  Result := False;

  try
    List := TStringList.Create;

    SplitString(strFont, '|', List);

    if List.Count < 5 then Exit;

    Font.Name := List[0];
    Font.Style := StrToFontStyles(List[1]);
    Font.Size := StrToInt(List[2]);
    Font.Color := StrToInt(List[3]);
    Font.Charset := StrToInt(List[4]);

    Result := True;
  finally
    List.Free;
  end;
end;

procedure LoadSettings;
var
  IniFile: TIniFile;
  IniFileName: string;
  i: Cardinal;
begin
  //TraceMsg('LoadSettings');

  IniFileName := ExtractFilePath(Application.ExeName) + TITLE + '.ini';

  IniFile := TIniFile.Create(IniFileName);
  HotKeyStr1 := IniFile.ReadString(SECTION_CONFIG, KEY_HOTKEY1, 'Alt + R');
  HotKeyStr2 := IniFile.ReadString(SECTION_CONFIG, KEY_HOTKEY2, 'Pause');
  LastItemHotKeyStr := IniFile.ReadString(SECTION_CONFIG, KEY_LASTITEMHOTKEY, 'ALT+L');
  AutoRun := IniFile.ReadBool(SECTION_CONFIG, KEY_AUTORUN, True);
  AddToSendTo := IniFile.ReadBool(SECTION_CONFIG, KEY_ADDTOSENDTO, True);
  EnableRegex := IniFile.ReadBool(SECTION_CONFIG, KEY_REGEX, True);
  HideDelay := IniFile.ReadInteger(SECTION_CONFIG, KEY_HIDEDELAY, 15);
  MatchAnywhere := IniFile.ReadBool(SECTION_CONFIG, KEY_MATCHANYWHERE, True);
  EnableNumberKey := IniFile.ReadBool(SECTION_CONFIG, KEY_NUMBERKEY, True);
  IndexFrom0to9 := IniFile.ReadBool(SECTION_CONFIG, KEY_INDEXFROM0TO9, False);
  RememberFavouratMatch := IniFile.ReadBool(SECTION_CONFIG, KEY_REMEMBERFAVOURATMATCH, False);
  ParamHistoryLimit := IniFile.ReadInteger(SECTION_CONFIG, KEY_PARAMHISTORYLIMIT, 50);
  ShowOperationHint := IniFile.ReadBool(SECTION_CONFIG, KEY_SHOWOPERATIONHINT, True);
  ShowCommandLine := IniFile.ReadBool(SECTION_CONFIG, KEY_SHOWCOMMANDLINE, True);
  ShowStartNotification := IniFile.ReadBool(SECTION_CONFIG, KEY_SHOWSTARTNOTIFICATION, True);
  ShowTopTen := IniFile.ReadBool(SECTION_CONFIG, KEY_SHOWTOPTEN, True);
  PlayPopupNotify := IniFile.ReadBool(SECTION_CONFIG, KEY_PLAYPOPUPNOTIFY, True);
  ExitWhenExecute := IniFile.ReadBool(SECTION_CONFIG, KEY_EXITWHENEXECUTE, False);
  ShowSkin := IniFile.ReadBool(SECTION_CONFIG, KEY_SHOWSKIN, True);
  ShowMeWhenStart := IniFile.ReadBool(SECTION_CONFIG, KEY_SHOWMEWHENSTART, False);
  ShowTrayIcon := IniFile.ReadBool(SECTION_CONFIG, KEY_SHOWTRAYICON, True);
  ShowShortCutButton := IniFile.ReadBool(SECTION_CONFIG, KEY_SHOWSHORTCUTBUTTON, True);
  ShowConfigButton := IniFile.ReadBool(SECTION_CONFIG, KEY_SHOWCONFIGBUTTON, False);
  ShowCloseButton := IniFile.ReadBool(SECTION_CONFIG, KEY_SHOWCLOSEBUTTON, True);
  ExecuteIfOnlyOne := IniFile.ReadBool(SECTION_CONFIG, KEY_EXECUTEIFONLYONE, False);

  WinTop := IniFile.ReadInteger(SECTION_WINDOW, KEY_WINTOP, 0);
  WinLeft := IniFile.ReadInteger(SECTION_WINDOW, KEY_WINLEFT, 0);

  ManWinTop := IniFile.ReadInteger(SECTION_WINDOW, KEY_MANWINTOP, 0);
  ManWinLeft := IniFile.ReadInteger(SECTION_WINDOW, KEY_MANWINLEFT, 0);
  ManWinWidth := IniFile.ReadInteger(SECTION_WINDOW, KEY_MANWINWIDTH, 450);
  ManWinHeight := IniFile.ReadInteger(SECTION_WINDOW, KEY_MANWINHEIGHT, 240);

  for i := 0 to 3 do
    ManColWidth[i] := IniFile.ReadInteger(SECTION_WINDOW, KEY_MANCOLWIDTH+IntToStr(i), 100);

  //删除老的配置字段
  IniFile.DeleteKey(SECTION_GUI, KEY_TITLECOLOR);
  IniFile.DeleteKey(SECTION_GUI, KEY_KEYWORDCOLOR);
  IniFile.DeleteKey(SECTION_GUI, KEY_LISTCOLOR);

  BGFileName := IniFile.ReadString(SECTION_GUI, KEY_BGFILENAME, DEFAULT_BGFILENAME);
  if Trim(BGFileName) = '' then BGFileName := DEFAULT_BGFILENAME;

  TitleFontStr := IniFile.ReadString(SECTION_GUI, KEY_TITLEFONT, DEFAULT_TITLE_FONT_STR);
  if Trim(TitleFontStr) = '' then TitleFontStr := DEFAULT_TITLE_FONT_STR;
  KeywordFontStr := IniFile.ReadString(SECTION_GUI, KEY_KEYWORDFONT, DEFAULT_KEYWORD_FONT_STR);
  if Trim(KeywordFontStr) = '' then KeywordFontStr := DEFAULT_KEYWORD_FONT_STR;
  ListFontStr := IniFile.ReadString(SECTION_GUI, KEY_LISTFONT, DEFAULT_LIST_FONT_STR);
  if Trim(ListFontStr) = '' then ListFontStr := DEFAULT_LIST_FONT_STR;

  ListFormat := IniFile.ReadString(SECTION_GUI, KEY_LISTFORMAT, DEFAULT_LIST_FORMAT);

  AlphaColor := IniFile.ReadInteger(SECTION_GUI, KEY_ALPHACOLOR, DEFAULT_ALPHACOLOR);
  Alpha := IniFile.ReadInteger(SECTION_GUI, KEY_ALPHA, DEFAULT_ALPHA);
  RoundBorderRadius := IniFile.ReadInteger(SECTION_GUI, KEY_ROUNDBORDERRADIUS, DEFAULT_ROUNDBORDERRADIUS);
  FormWidth := IniFile.ReadInteger(SECTION_GUI, KEY_FORMWIDTH, DEFAULT_FORMWIDTH);

  // 如果当前用户的默认语言是简体中文
  if GetSystemDefaultLangID = 2052 then
    Lang := IniFile.ReadString(SECTION_GUI, KEY_LANG, '简体中文')
  else
    Lang := IniFile.ReadString(SECTION_GUI, KEY_LANG, DEFAULT_LANG);

  TraceEnable := IniFile.ReadBool(SECTION_DEBUG, KEY_TRACEENABLE, False);

  ShortCutRunCount := IniFile.ReadInteger(SECTION_DEBUG, KEY_SHORTCUTRUNCOUNT, 0);
  HandleID := IniFile.ReadInteger(SECTION_DEBUG, KEY_HANDLEID, 0);

  //ModifyTime := IniFile.ReadString(SECTION_DEBUG, KEY_MODIFYTIME, '');
  LatestList := IniFile.ReadString(SECTION_DEBUG, KEY_LATESTLIST, '');

  IniFile.Destroy;
end;

procedure SaveSettings;
var
  IniFile: TIniFile;
  IniFileName: string;
  i: Cardinal;
begin
  TraceMsg('SaveSettings');

  IniFileName := ExtractFilePath(Application.ExeName) + TITLE + '.ini';

  IniFile := TIniFile.Create(IniFileName);
  IniFile.WriteString(SECTION_CONFIG, KEY_HOTKEY1, HotKeyStr1);
  IniFile.WriteString(SECTION_CONFIG, KEY_HOTKEY2, HotKeyStr2);
  IniFile.WriteString(SECTION_CONFIG, KEY_LASTITEMHOTKEY, LastItemHotKeyStr);
  IniFile.WriteBool(SECTION_CONFIG, KEY_AUTORUN, AutoRun);
  IniFile.WriteBool(SECTION_CONFIG, KEY_ADDTOSENDTO, AddToSendTo);
  IniFile.WriteBool(SECTION_CONFIG, KEY_REGEX, EnableRegex);
  IniFile.WriteInteger(SECTION_CONFIG, KEY_HIDEDELAY, HideDelay);
  IniFile.WriteBool(SECTION_CONFIG, KEY_MATCHANYWHERE, MatchAnywhere);
  IniFile.WriteBool(SECTION_CONFIG, KEY_NUMBERKEY, EnableNumberKey);
  IniFile.WriteBool(SECTION_CONFIG, KEY_INDEXFROM0TO9, IndexFrom0to9);
  IniFile.WriteBool(SECTION_CONFIG, KEY_REMEMBERFAVOURATMATCH, RememberFavouratMatch);
  IniFile.WriteInteger(SECTION_CONFIG, KEY_PARAMHISTORYLIMIT, ParamHistoryLimit);
  IniFile.WriteBool(SECTION_CONFIG, KEY_SHOWOPERATIONHINT, ShowOperationHint);
  IniFile.WriteBool(SECTION_CONFIG, KEY_SHOWCOMMANDLINE, ShowCommandLine);
  IniFile.WriteBool(SECTION_CONFIG, KEY_SHOWSTARTNOTIFICATION, ShowStartNotification);
  IniFile.WriteBool(SECTION_CONFIG, KEY_SHOWTOPTEN, ShowTopTen);
  IniFile.WriteBool(SECTION_CONFIG, KEY_PLAYPOPUPNOTIFY, PlayPopupNotify);
  IniFile.WriteBool(SECTION_CONFIG, KEY_EXITWHENEXECUTE, ExitWhenExecute);
  IniFile.WriteBool(SECTION_CONFIG, KEY_SHOWSKIN, ShowSkin);
  IniFile.WriteBool(SECTION_CONFIG, KEY_SHOWMEWHENSTART, ShowMeWhenStart);
  IniFile.WriteBool(SECTION_CONFIG, KEY_SHOWTRAYICON, ShowTrayIcon);
  IniFile.WriteBool(SECTION_CONFIG, KEY_SHOWSHORTCUTBUTTON, ShowShortCutButton);
  IniFile.WriteBool(SECTION_CONFIG, KEY_SHOWCONFIGBUTTON, ShowConfigButton);
  IniFile.WriteBool(SECTION_CONFIG, KEY_SHOWCLOSEBUTTON, ShowCloseButton);
  IniFile.WriteBool(SECTION_CONFIG, KEY_EXECUTEIFONLYONE, ExecuteIfOnlyOne);

  IniFile.WriteInteger(SECTION_WINDOW, KEY_WINTOP, WinTop);
  IniFile.WriteInteger(SECTION_WINDOW, KEY_WINLEFT, WinLeft);

  IniFile.WriteInteger(SECTION_WINDOW, KEY_MANWINTOP, ManWinTop);
  IniFile.WriteInteger(SECTION_WINDOW, KEY_MANWINLEFT, ManWinLeft);
  IniFile.WriteInteger(SECTION_WINDOW, KEY_MANWINWIDTH, ManWinWidth);
  IniFile.WriteInteger(SECTION_WINDOW, KEY_MANWINHEIGHT, ManWinHeight);

  for i := 0 to 3 do
    IniFile.WriteInteger(SECTION_WINDOW, KEY_MANCOLWIDTH+IntToStr(i), ManColWidth[i]);

  IniFile.WriteString(SECTION_GUI, KEY_BGFILENAME, BGFileName);
  IniFile.WriteString(SECTION_GUI, KEY_TITLEFONT, TitleFontStr);
  IniFile.WriteString(SECTION_GUI, KEY_KEYWORDFONT, KeywordFontStr);
  IniFile.WriteString(SECTION_GUI, KEY_LISTFONT, ListFontStr);

  IniFile.WriteString(SECTION_GUI, KEY_LISTFORMAT, ListFormat);

  IniFile.WriteInteger(SECTION_GUI, KEY_ALPHACOLOR, AlphaColor);
  IniFile.WriteInteger(SECTION_GUI, KEY_ALPHA, Alpha);
  IniFile.WriteInteger(SECTION_GUI, KEY_ROUNDBORDERRADIUS, RoundBorderRadius);
  IniFile.WriteInteger(SECTION_GUI, KEY_FORMWIDTH, FormWidth);
  IniFile.WriteString(SECTION_GUI, KEY_LANG, Lang);

  //TraceEnable仅供手工修改
  //IniFile.WriteBool(SECTION_DEBUG, KEY_TRACEENABLE, TraceEnable);

  IniFile.WriteInteger(SECTION_DEBUG, KEY_SHORTCUTRUNCOUNT, ShortCutRunCount);
  IniFile.WriteInteger(SECTION_DEBUG, KEY_HANDLEID, HandleID);
  //IniFile.WriteString(SECTION_DEBUG, KEY_MODIFYTIME, GetFileModifyTime(ShortCutListFileName));
  IniFile.WriteString(SECTION_DEBUG, KEY_LATESTLIST, LatestList);

  IniFile.Free;
end;

procedure SetActiveLanguage;
var
  IniFile: TIniFile;
  IniFileName: string;
begin
  //TraceMsg('SetActiveLanguage');

  IniFileName := ExtractFilePath(Application.ExeName) + Lang + '.lang';
  IniFile := TIniFile.Create(IniFileName);

  //----- Common
  resInfo := IniFile.ReadString(SECTION_COMMON, KEY_INFO, 'Info');
  resAbout := IniFile.ReadString(SECTION_COMMON, KEY_ABOUT, 'About');
  resDelete := IniFile.ReadString(SECTION_COMMON, KEY_DELETE, 'Delete');
  resWarning := IniFile.ReadString(SECTION_COMMON, KEY_WARNING, 'Warning');
  resWordOr := IniFile.ReadString(SECTION_COMMON, KEY_WORDOR, 'Or');
  resWordAnd := IniFile.ReadString(SECTION_COMMON, KEY_WORDAND, 'And');

  resMenuShow := IniFile.ReadString(SECTION_COMMON, KEY_MENUSHOW, 'Show');
  resMenuShortCut := IniFile.ReadString(SECTION_COMMON, KEY_MENUSHORTCUT, 'ShortCut');
  resMenuConfig := IniFile.ReadString(SECTION_COMMON, KEY_MENUCONFIG, 'Config');
  resMenuAbout := IniFile.ReadString(SECTION_COMMON, KEY_MENUABOUT, 'About');
  resMenuClose := IniFile.ReadString(SECTION_COMMON, KEY_MENUCLOSE, 'Close');

  resBtnOK := IniFile.ReadString(SECTION_COMMON, KEY_BTNOK, 'OK');
  resBtnCancel := IniFile.ReadString(SECTION_COMMON, KEY_BTNCANCEL, 'Cancel');
  resBtnReset := IniFile.ReadString(SECTION_COMMON, KEY_BTNRESET, 'Reset');
  resBtnHelp := IniFile.ReadString(SECTION_COMMON, KEY_BTNHELP, 'Help');
  resBtnTest := IniFile.ReadString(SECTION_COMMON, KEY_BTNTEST, 'Test');
  resBtnAdd := IniFile.ReadString(SECTION_COMMON, KEY_BTNADD, 'Add');
  resBtnEdit := IniFile.ReadString(SECTION_COMMON, KEY_BTNEDIT, 'Edit');
  resBtnDelete := IniFile.ReadString(SECTION_COMMON, KEY_BTNDELETE, 'Delete');
  resBtnPathConvert := IniFile.ReadString(SECTION_COMMON, KEY_BTNPATHCONVERT, 'Path Convert');
  resBtnValidate := IniFile.ReadString(SECTION_COMMON, KEY_BTNVALIDATE, 'Validate');
  resBtnClose := IniFile.ReadString(SECTION_COMMON, KEY_BTNCLOSE, 'Close');

  resShortCut := IniFile.ReadString(SECTION_COMMON, KEY_SHORTCUT, 'ShortCut');
  resName := IniFile.ReadString(SECTION_COMMON, KEY_NAME, 'Name');
  resParamType := IniFile.ReadString(SECTION_COMMON, KEY_PARAMTYPE, 'ParamType');
  resCommandLine := IniFile.ReadString(SECTION_COMMON, KEY_COMMANDLINE, 'CommandLine');
  resCanNotExecute := IniFile.ReadString(SECTION_COMMON, KEY_CANNOTEXECUTE, 'Can not execute "%s %s"');

  //----- ALTRunForm
  resStarted := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_STARTED, '%s %s is started,');
  resPressKeyToShowMe := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_PRESSKEYTOSHOWME, 'You can press %s to show me');
  resMainHint := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_MAINHINT, '%s %s%s[HotKey = %s]');
  resShowMeByHotKey := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_SHOWMEBYHOTKEY, 'It''s better to show me by press hotkey %s');
  resNoItemAndAdd := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_NOITEMANDADD, 'No such item "%s", add this shortcut?');
  resHotKeyError := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HOTKEYERROR, 'HotKey can not be "%s"');
  resCMDLine := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_CMDLINE, 'CMD=');
  resRunNum := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_RUNNUM, 'Press ALT+%s or CTRL+%s to run ShortCut');
  resKeyToAdd := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_KEYTOADD, 'Press ENTER to ADD this ShortCut');
  resKeyToOpenFolder := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_KEYTOOPENFOLDER, 'Press CTRL+D to OPEN FOLDER of this ShortCut');
  resKeyToRun := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_KEYTORUN, 'Press ENTER or SPACE to RUN ShortCut');
  resAutoRunWhenStart := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_AUTORUNWHENSTART, 'Do you want run me when system started?');
  resAddToSendToMenu := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_ADDTOSENDTOMENU, 'Do you want add me into SendTo menu?');
  resRestartMeInfo := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_RESTARTMEINFO, 'Some change of config need to restart me right now.');
  resCleanConfirm := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_CLEANCONFIRM, 'Confirm to disable autorun when system started, and remove me from "SendTo" menu?');
  resRelativePathSuggestion := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_RELATIVEPATHSUGGESTION, 'Replace absolute path with relative path? It is better for portable use.');
  resGetFileNameFail := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_GETFILENAMEFAIL, 'Can not get file name!');
  resShortCutExisted := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_SHORTCUTEXISTED, 'The ShortCut with same shortcut has already existed [%s (%s) = %s]. Replace it?');
  resCongratulations := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_CONGRATULATIONS, 'Congratulations! You have executed %d times!');
  resBlankLineAdded := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_BLANKLINEADDED, 'Blank line added.');

  resBtnShortCutHint := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_BTNSHORTCUTHINT, 'Press ALT+S to show ShortCut Manager');
  resBtnConfigHint := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_BTNCONFIGHINT, 'Press ALT+C to show Config Manager');
  resBtnFakeCloseHint := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_BTNFAKECLOSEHINT, 'Press ESC to hide me');
  resEdtShortCutHint := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_EDTSHORTCUTHINT, 'Type Keyword here, then press ENTER');

  HintList[0] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_0, 'Press INSERT to add new ShortCut');
  HintList[1] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_1, 'Press F2 to rename this ShortCut');
  HintList[2] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_2, 'Press DELETE to delete this ShortCut');
  HintList[3] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_3, 'Press F1 to show About');
  HintList[4] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_4, 'Press ESC to hide me');
  HintList[5] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_5, 'Type "b" to search by Baidu');
  HintList[6] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_6, 'Type "g" to search by Google');
  HintList[7] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_7, 'Type "s" to search MP3 by Sogou');
  HintList[8] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_8, 'Type "zd" to search by Baidu Zhidao');
  HintList[9] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_9, 'Press ALT+C to show Config Manager');
  HintList[10] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_10, 'Press CTRL+D to open folder of some ShortCut');
  HintList[11] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_11, 'You can disable this hint by config');
  HintList[12] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_12, 'You can disable the CMD line by config');
  HintList[13] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_13, 'Please manually backup ShortCutList.txt in time');
  HintList[14] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_14, 'Press CTRL+C to copy CMD line to Clipboard');
  HintList[15] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_15, 'Press SPACE or ENTER to execute ShortCut');
  HintList[16] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_16, 'Type ";" to execute the 2nd item');
  HintList[17] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_17, 'Type "''" to execute the 3rd item');
  HintList[18] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_18, 'Press CTRL+L to show latest ShortCut');
  HintList[19] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_19, 'Press TAB to show next ShortCut');
  HintList[20] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_20, 'Press Shift+TAB to show previous ShortCut');
  HintList[21] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_21, 'Type "cb" to search Clipboard text by Baidu');
  HintList[22] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_22, 'Type "cg" to search Clipboard text by Google');
  HintList[23] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_23, 'Scroll Mouse to change selected ShortCut');
  HintList[24] := IniFile.ReadString(SECTION_ALTRUNFORM, KEY_HINTLIST_24, 'Click middle button of Mouse to execute ShortCut');

  //----- ConfigForm
  resPageConfig := IniFile.ReadString(SECTION_CONFIGFORM, KEY_PAGECONFIG, 'Config');
  resPageHotKey := IniFile.ReadString(SECTION_CONFIGFORM, KEY_PAGEHOTKEY, 'HotKey');
  resPageFont := IniFile.ReadString(SECTION_CONFIGFORM, KEY_PAGEFONT, 'Font');
  resPageForm := IniFile.ReadString(SECTION_CONFIGFORM, KEY_PAGEFORM, 'Form');
  resPageLang := IniFile.ReadString(SECTION_CONFIGFORM, KEY_PAGELANG, 'Language');

  resConfigFormCaption := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGFORMCAPTION, 'Config');
  resResetAllConfig := IniFile.ReadString(SECTION_CONFIGFORM, KEY_RESETALLCONFIG, 'Reset all config settings to default value?');
  resResetAllFonts := IniFile.ReadString(SECTION_CONFIGFORM, KEY_RESETALLFONTS, 'Reset all Fonts to default value?');
  resVoidHotKey := IniFile.ReadString(SECTION_CONFIGFORM, KEY_VOIDHOTKEY, 'NONE');

  resLblHotKey1 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLHOTKEY1, 'Primary HotKey');
  resLblHotKey2 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLHOTKEY2, 'Secondary HotKey');
  resLblTitleFont := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLTITLEFONT, 'Title Font');
  resLblTitleSample := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLTITLESAMPLE, 'Title Sample');
  resLblKeywordFont := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLKEYWORDFONT, 'Keyword Font');
  resLblKeywordSample := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLKEYWORDSAMPLE, 'Keyword Sample');
  resLblListFont := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLLISTFONT, 'List Font');
  resLblListSample := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLLISTSAMPLE, 'List Sample');
  resLblListFormat := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLLISTFORMAT, 'List Format');
  resLblResetFont := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLRESETFONT, 'Reset All Fonts');
  resLblFormatSample := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLFORMATSAMPLE, 'Format Sample');
  resLblListFormatSample := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLLISTFORMATSAMPLE, 'List Format Sample');
  resLblFormAlphaColor := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLFORMALPHACOLOR, 'Form Alpha Color');
  resLblFormAlpha := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLFORMALPHA, 'FormAlpha');
  resLblRoundBorderRadius := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLROUNDBORDERRADIUS, 'Round Border Radius');
  resLblFormWidth := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLFORMWIDTH, 'Form Width (Pixel)');
  resLblBackGroundImage := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLBACKGROUNDIMAGE, 'Back Ground Image');
  resLblAlphaHint := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLALPHAHINT, 'Form Setting will take into effect when next start up');
  resLblLanguage := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLLANGUAGE, 'Language');
  resLblLanguageHint := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLLANGUAGEHINT, 'Language Setting will take into effect when next start up');
  resLblHotKeyHint := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLHOTKEYHINT, 'You can choose another hot key as secondary hot key');
  resLblHotKeyHint1 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLHOTKEYHINT1, 'Type keyboard to select one key, this is the primary hot key');
  resLblHotKeyHint2 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_LBLHOTKEYHINT2, 'Type keyboard to select one key, this is the secondary hot key. You can type DELETE key to disable secondary hot key');

  resBtnModifyTitleFont := IniFile.ReadString(SECTION_CONFIGFORM, KEY_BTNMODIFYTITLEFONT, 'Modify Title Font');
  resBtnModifyKeywordFont := IniFile.ReadString(SECTION_CONFIGFORM, KEY_BTNMODIFYKEYWORDFONT, 'Modify Keyword Font');
  resBtnModifyListFont := IniFile.ReadString(SECTION_CONFIGFORM, KEY_BTNMODIFYLISTFONT, 'Modify List Font');
  resBtnResetAllFonts := IniFile.ReadString(SECTION_CONFIGFORM, KEY_BTNRESETALLFONTS, 'Reset All Fonts');

  resConfigList_0 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_0, 'Auto run me when Windows start');
  resConfigList_1 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_1, 'Add HotRun to SendTo Menu');
  resConfigList_2 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_2, 'Enable Regex (Wild char = *, ?)');
  resConfigList_3 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_3, 'Match Keyword from Anywhere');
  resConfigList_4 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_4, 'Enable Number Key');
  resConfigList_5 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_5, 'Index = 0, 1, ..., 8, 9');
  resConfigList_6 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_6, 'Remember Last ShortCut Match');
  resConfigList_7 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_7, 'Show Hint');
  resConfigList_8 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_8, 'Show Command Line');
  resConfigList_9 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_9, 'Show Start Notification');
  resConfigList_10 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_10, 'Show Top 10 Only');
  resConfigList_11 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_11, 'Play Popup Notify');
  resConfigList_12 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_12, 'Exit When Execute');
  resConfigList_13 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_13, 'Show Skin');
  resConfigList_14 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_14, 'Show When Start');
  resConfigList_15 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_15, 'Show Tray Icon');
  resConfigList_16 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_16, 'Show ShortCut Manager Button');
  resConfigList_17 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_17, 'Show Config Button');
  resConfigList_18 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_18, 'Show Close Button');
  resConfigList_19 := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGLIST_19, 'Execute Immediately If Only One Matched');

  ConfigDescList[0] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_0, 'If checked, auto run me when windows startup');
  ConfigDescList[1] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_1, 'If checked, add HotRun into SendTo menu');
  ConfigDescList[2] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_2, 'If checked, enable wild char (such as *,?)');
  ConfigDescList[3] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_3, 'If UNCHECKED, match keyword from the first char');
  ConfigDescList[4] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_4, 'If checked, type number 0-9 to launch shortcut item');
  ConfigDescList[5] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_5, 'If UNCHECKED, Index is 1, 2, ..., 9, 0');
  ConfigDescList[6] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_6, 'If checked, Only Remember the Last ShortCut Match');
  ConfigDescList[7] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_7, 'If checked, Show Hint in EditBox');
  ConfigDescList[8] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_8, 'If checked, Show Command Line in bottom');
  ConfigDescList[9] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_9, 'If checked, Show Ballon NotificationLine when start up');
  ConfigDescList[10] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_10, 'If checked, Show Top 10 only');
  ConfigDescList[11] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_11, 'If checked, Play notify sound when main window popup');
  ConfigDescList[12] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_12, 'If checked, Application will exit when shortcut executed');
  ConfigDescList[13] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_13, 'If UNCHECKED, Unload skin picture');
  ConfigDescList[14] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_14, 'If checked, Show me when started');
  ConfigDescList[15] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_15, 'If checked, Show Tray Icon');
  ConfigDescList[16] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_16, 'If checked, Show ShortCut Manager Button');
  ConfigDescList[17] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_17, 'If checked, Show Config Button');
  ConfigDescList[18] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_18, 'If checked, Show Close Button');
  ConfigDescList[19] := IniFile.ReadString(SECTION_CONFIGFORM, KEY_CONFIGDESCLIST_19, 'If checked, Execute immediately if only one ShortCut matched');

  //InvalidForm
  resInvalidFormCaption := IniFile.ReadString(SECTION_INVALIDFORM, KEY_INVALIDFORMCAPTION, 'Invalid ShortCut List');
  resCommandLineEempty := IniFile.ReadString(SECTION_INVALIDFORM, KEY_COMMANDLINEEMPTY, 'CommandLine is empty!');

  //ShortCutManForm
  resShortCutManFormCaption := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_SHORTCUTMANFORMCAPTION, 'ShortCut Manager');
  resNoInvalidShortCut := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_NOINVALIDSHORTCUT, 'No Invalid ShortCut found.');
  resDeleteBlankLine := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_DELETEBLANKLINET, 'Delete Blank Line?');
  resDeleteConfirm := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_DELETECONFIRM, 'Delete %s(%s)?');
  resValidateConfirm := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_VALIDATECONFIRM, 'Validate will remove some invalid ShortCut (NOT ALL invalid ones will be checked out), do you still want go?');
  resPathConvertConfirm := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_PATHCONVERTCONFIRM, 'Switch Absolute path with Relative path for all shortcut(Only shortcuts where in ALTRun folder will be handled)?%sYES: for Absolute path => Relative path%sNO: Relative path => Absolute path');
  resConvertFinished := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_CONVERTFINISHED, 'Convert finished (Count = %d)');

  resBtnAddHint := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_BtnAddHint, 'Add new ShortCut item');
  resBtnEditHint := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_BtnEditHint, 'Edit this ShortCut item');
  resBtnDeleteHint := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_BtnDeleteHint, 'Delete this ShortCut item');
  resBtnPathConvertHint := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_BtnPathConvertHint, 'Convert Absolute Path and Relative Path');
  resBtnValidateHint := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_BtnValidateHint, 'Validate all ShortCuts and remove invalid ones');
  resBtnHelpHint := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_BtnHelpHint, 'Show Help');
  resBtnCloseHint := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_BtnCloseHint, 'Save and close');
  resBtnCancelHint := IniFile.ReadString(SECTION_SHORTCUTMANFORM, KEY_BtnCancelHint, 'Not save and close');

  //ShortCutForm
  resShortCutFormCaption := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_ShortCutFormCaption, 'ShortCut');
  resGrpShortCut := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_GrpShortCut, 'ShortCut');
  resBtnFile := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_BtnFile, 'File');
  resBtnDir := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_BtnDir, 'Dir');
  resGrpParamType := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_GrpParamType, 'Param Type');
  resLblEdtCommandLineHint := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_LblEdtCommandLineHint, '"%p" in Command Line will be replaced with param, and "%c" will be replaced with Clipboard text');
  resParamType_0 := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_ParamType_0, 'No Param');
  resParamType_1 := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_ParamType_1, 'Param without encoding');
  resParamType_2 := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_ParamType_2, 'Param with URL encoding (e.g. Baidu search query)');
  resParamType_3 := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_ParamType_3, 'Param with UTF-8 encoding (e.g. Google/Yahoo search query)');

  resSelectDir := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_SELECTDIR, 'Please select directory');
  resParamConfirm := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_PARAMCONFIRM, 'Seems forget to choose a Param Type, back to choose one?');
  resReplaceConfirm := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_REPLACECONFIRM, 'Replace "%s" with "%s"?');
  resReplaceShortCutConfirm := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_REPLACESHORTCUTCONFIRM, 'Replace ShortCut Confirm');
  resReplaceNameConfirm := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_REPLACENAMECONFIRM, 'Replace Name Confirm');
  resNameCanNotInclude := IniFile.ReadString(SECTION_SHORTCUTFORM, KEY_NAMECANNOTINCLUDE, 'Name can not include ","');

  //AboutForm
  resStatistics := IniFile.ReadString(SECTION_ABOUTFORM, KEY_STATISTICS, 'You have run shortcut %d times by now');

  //Default_ShortCut_Name
  resDefault_ShortCut_Name_0 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_0, 'My Computer');
  resDefault_ShortCut_Name_1 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_1, 'Explorer');
  resDefault_ShortCut_Name_2 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_2, 'My Document');
  resDefault_ShortCut_Name_3 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_3, 'Internet Explorer');
  resDefault_ShortCut_Name_4 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_4, 'Notepad');
  resDefault_ShortCut_Name_5 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_5, 'MS Paint');
  resDefault_ShortCut_Name_6 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_6, 'Dos Shell');
  resDefault_ShortCut_Name_7 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_7, 'Calculator');
  resDefault_ShortCut_Name_8 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_8, 'Show Desktop');
  resDefault_ShortCut_Name_9 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_9, 'System Config');
  resDefault_ShortCut_Name_10 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_10, 'Registry Editor');
  resDefault_ShortCut_Name_11 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_11, 'My IP address');
  resDefault_ShortCut_Name_12 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_12, 'Device Manager');
  resDefault_ShortCut_Name_13 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_13, 'Task Manager');
  resDefault_ShortCut_Name_14 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_14, 'Shutdown Computer');
  resDefault_ShortCut_Name_15 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_15, 'Reboot Computer');
  resDefault_ShortCut_Name_16 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_16, 'Windows Directory');
  resDefault_ShortCut_Name_17 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_17, 'System32 Directory');
  resDefault_ShortCut_Name_18 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_18, 'Program Files Directory');
  resDefault_ShortCut_Name_19 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_19, 'Recent Directory');
  resDefault_ShortCut_Name_20 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_20, 'Baidu Search Engine');
  resDefault_ShortCut_Name_21 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_21, 'Google Search Engine');
  resDefault_ShortCut_Name_22 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_22, 'Sogou MP3 Search Engine');
  resDefault_ShortCut_Name_23 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_23, 'Baidu Zhidao Search Engine');
  resDefault_ShortCut_Name_24 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_24, 'VeryCD Search Engine');
  resDefault_ShortCut_Name_25 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_25, 'Yahoo Search Engine');
  resDefault_ShortCut_Name_26 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_26, 'Go to ALTRun Upgrade Site');
  resDefault_ShortCut_Name_27 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_27, 'Edit ALTRun Config');
  resDefault_ShortCut_Name_28 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_28, 'Add/Remove Program');
  resDefault_ShortCut_Name_29 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_29, 'Control Panel');
  resDefault_ShortCut_Name_30 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_30, 'Internet Connection');
  resDefault_ShortCut_Name_31 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_31, 'System Property');
  resDefault_ShortCut_Name_32 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_32, 'Run');
  resDefault_ShortCut_Name_33 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_33, 'Baidu Search Clipboard');
  resDefault_ShortCut_Name_34 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_34, 'Google Search Clipboard');
  resDefault_ShortCut_Name_35 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_35, 'Show Window');
  resDefault_ShortCut_Name_36 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_36, 'Hide');
  resDefault_ShortCut_Name_37 := IniFile.ReadString(SECTION_DEFAULTSHORTCUTLIST, KEY_DEFAULTSHORTCUTLIST_37, 'UnHide');

  IniFile.Destroy;
end;
end.

