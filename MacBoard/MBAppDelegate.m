//
//  MBAppDelegate.m
//  MacBoard
//
//  Created by C.W. Betts on 12/17/13.
//  Copyright (c) 2013 GNU Software. All rights reserved.
//

#import "MBAppDelegate.h"
#include "backend.h"
#include "menus.h"

#ifdef ENABLE_NLS
# define  _(s) gettext (s)
# define N_(s) gettext_noop (s)
#else
# define  _(s) (s)
# define N_(s)  s
#endif

AppData appData;

@implementation MBAppDelegate

+ (void)initialize
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[[NSUserDefaults standardUserDefaults] registerDefaults:@{}];
	});
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
}

- (BOOL)addEngineToMenu:(NSString*)theNewItem
{
	return NO;
}

- (IBAction)loadNextGame:(id)sender
{
	ReloadGame(1);
}

- (IBAction)loadPreviousGame:(id)sender
{
	ReloadGame(-1);
}

- (IBAction)reloadGame:(id)sender
{
	ReloadGame(0);
}

- (IBAction)loadNextPosition:(id)sender
{
	ReloadPosition(1);
}

- (IBAction)loadPreviousPosition:(id)sender
{
	ReloadPosition(-1);
}

- (IBAction)reloadPosition:(id)sender
{
	ReloadPosition(0);
}

- (IBAction)loadGame:(id)sender
{
	if (gameMode == AnalyzeMode || gameMode == AnalyzeFile) {
		Reset(FALSE, TRUE);
    }
	//NSOpenPanel
}
- (IBAction)loadPosition:(id)sender
{
	if (gameMode == AnalyzeMode || gameMode == AnalyzeFile) {
		Reset(FALSE, TRUE);
    }
	//NSOpenPanel
}

- (IBAction)saveGame:(id)sender
{
	//NSSavePanel
}

- (IBAction)bugReport:(id)sender
{
    char buf[MSG_SIZ];
    snprintf(buf, MSG_SIZ, "%s mailto:bug-xboard@gnu.org", appData.sysOpen);
    system(buf);
}

- (IBAction)showUserGuide:(id)sender
{
    char buf[MSG_SIZ];
    snprintf(buf, MSG_SIZ, "%s http://www.gnu.org/software/xboard/user_guide/UserGuide.html", appData.sysOpen);
    system(buf);
}


- (IBAction)goToHomePage:(id)sender
{
    char buf[MSG_SIZ];
    snprintf(buf, MSG_SIZ, "%s http://www.gnu.org/software/xboard/", appData.sysOpen);
    system(buf);
}

- (IBAction)goToNewsPage:(id)sender
{
    char buf[MSG_SIZ];
    snprintf(buf, MSG_SIZ, "%s http://www.gnu.org/software/xboard/whats_new/portal.html", appData.sysOpen);
    system(buf);
}

- (IBAction)saveOnExitToggle:(id)sender
{
	
}

@end


static int
LoadGamePopUp (FILE *f, int gameNumber, char *title)
{
    cmailMsgLoaded = FALSE;
    if (gameNumber == 0) {
		int error = GameListBuild(f);
		if (error) {
			DisplayError(_("Cannot build game list"), error);
		} else if (!ListEmpty(&gameList) &&
				   ((ListGame *) gameList.tailPred)->number > 1) {
			GameListPopUp(f, title);
			return TRUE;
		}
		GameListDestroy();
		gameNumber = 1;
    }
    return LoadGame(f, gameNumber, title, FALSE);
}

void
LoadGameProc ()
{
    if (gameMode == AnalyzeMode || gameMode == AnalyzeFile) {
		Reset(FALSE, TRUE);
    }
    FileNamePopUp(_("Load game file name?"), "", ".pgn .game", LoadGamePopUp, "rb");
}

void
LoadPositionProc()
{
    if (gameMode == AnalyzeMode || gameMode == AnalyzeFile) {
		Reset(FALSE, TRUE);
    }
    FileNamePopUp(_("Load position file name?"), "", ".fen .epd .pos", LoadPosition, "rb");
}

void
SaveGameProc ()
{
    FileNamePopUp(_("Save game file name?"),
				  DefaultFileName(appData.oldSaveStyle ? "game" : "pgn"),
				  appData.oldSaveStyle ? ".game" : ".pgn",
				  SaveGame, "a");
}

void
SavePositionProc ()
{
    FileNamePopUp(_("Save position file name?"),
				  DefaultFileName(appData.oldSaveStyle ? "pos" : "fen"),
				  appData.oldSaveStyle ? ".pos" : ".fen",
				  SavePosition, "a");
}

void
ReloadCmailMsgProc ()
{
    ReloadCmailMsgEvent(FALSE);
}

void
CopyFENToClipboard ()
{ // wrapper to make call from back-end possible
	CopyPositionProc();
}

void
CopyPositionProc ()
{
    static char *selected_fen_position=NULL;
    if(gameMode == EditPosition) EditPositionDone(TRUE);
    if (selected_fen_position) free(selected_fen_position);
    selected_fen_position = (char *)PositionToFEN(currentMove, NULL);
    if (!selected_fen_position) return;
    CopySomething(selected_fen_position);
}

void
CopyGameProc ()
{
	int ret;
	
	ret = SaveGameToFile(gameCopyFilename, FALSE);
	if (!ret) return;
	
	CopySomething(NULL);
}

void
CopyGameListProc ()
{
	if(!SaveGameListAsText(fopen(gameCopyFilename, "w"))) return;
	CopySomething(NULL);
}

void
AutoSaveGame ()
{
    SaveGameProc();
}


void
QuitProc ()
{
    ExitEvent(0);
}

void
MatchProc ()
{
    MatchEvent(2);
}

void
AdjuWhiteProc ()
{
    UserAdjudicationEvent(+1);
}

void
AdjuBlackProc ()
{
    UserAdjudicationEvent(-1);
}

void
AdjuDrawProc ()
{
    UserAdjudicationEvent(0);
}

void
RevertProc ()
{
    RevertEvent(False);
}

void
AnnotateProc ()
{
    RevertEvent(True);
}

void
FlipViewProc ()
{
    if(twoBoards) { partnerUp = 1; DrawPosition(True, NULL); partnerUp = 0; }
    flipView = !flipView;
    DrawPosition(True, NULL);
}

void
SaveOnExitProc ()
{
	saveSettingsOnExit = !saveSettingsOnExit;
	
	MarkMenuItem("Options.SaveSettingsonExit", saveSettingsOnExit);
}

void
SaveSettingsProc ()
{
	SaveSettings(settingsFileName);
}

void
BugReportProc ()
{
    char buf[MSG_SIZ];
    snprintf(buf, MSG_SIZ, "%s mailto:bug-xboard@gnu.org", appData.sysOpen);
    system(buf);
}

void
GuideProc ()
{
    char buf[MSG_SIZ];
    snprintf(buf, MSG_SIZ, "%s http://www.gnu.org/software/xboard/user_guide/UserGuide.html", appData.sysOpen);
    system(buf);
}

void
HomePageProc ()
{
    char buf[MSG_SIZ];
    snprintf(buf, MSG_SIZ, "%s http://www.gnu.org/software/xboard/", appData.sysOpen);
    system(buf);
}

void
NewsPageProc ()
{
    char buf[MSG_SIZ];
    snprintf(buf, MSG_SIZ, "%s http://www.gnu.org/software/xboard/whats_new/portal.html", appData.sysOpen);
    system(buf);
}

void
AboutProc ()
{
    char buf[2 * MSG_SIZ];
#if ZIPPY
    char *zippy = _(" (with Zippy code)");
#else
    char *zippy = "";
#endif
    snprintf(buf, sizeof(buf),
			 _("%s%s\n\n"
			   "Copyright 1991 Digital Equipment Corporation\n"
			   "Enhancements Copyright 1992-2013 Free Software Foundation\n"
			   "Enhancements Copyright 2005 Alessandro Scotti\n\n"
			   "%s is free software and carries NO WARRANTY;"
			   "see the file COPYING for more information.\n"
			   "The GTK build of this version is experimental and unstable\n\n"
			   "Visit XBoard on the web at: http://www.gnu.org/software/xboard/\n"
			   "Check out the newest features at: http://www.gnu.org/software/xboard/whats_new.html\n\n"
			   "Report bugs via email at: <bug-xboard@gnu.org>\n\n"
			   ),
			 programVersion, zippy, PACKAGE);
    ErrorPopUp(_("About XBoard"), buf, FALSE);
}

void
DebugProc ()
{
    appData.debugMode = !appData.debugMode;
    if(!strcmp(appData.nameOfDebugFile, "stderr")) return; // stderr is already open, and should never be closed
    if(!appData.debugMode) fclose(debugFP);
    else {
		debugFP = fopen(appData.nameOfDebugFile, "w");
		if(debugFP == NULL) debugFP = stderr;
		else setbuf(debugFP, NULL);
    }
}

void
NothingProc ()
{
    return;
}

#ifdef OPTIONSDIALOG
#   define MARK_MENU_ITEM(X,Y)
#else
#   define MARK_MENU_ITEM(X,Y) MarkMenuItem(X, Y)
#endif

void
PonderNextMoveProc ()
{
	PonderNextMoveEvent(!appData.ponderNextMove);
	MARK_MENU_ITEM("Options.PonderNextMove", appData.ponderNextMove);
}

void
AlwaysQueenProc ()
{
    appData.alwaysPromoteToQueen = !appData.alwaysPromoteToQueen;
    MARK_MENU_ITEM("Options.AlwaysQueen", appData.alwaysPromoteToQueen);
}

void
AnimateDraggingProc ()
{
    appData.animateDragging = !appData.animateDragging;
	
    if (appData.animateDragging) CreateAnimVars();
    MARK_MENU_ITEM("Options.AnimateDragging", appData.animateDragging);
}

void
AnimateMovingProc ()
{
    appData.animate = !appData.animate;
    if (appData.animate) CreateAnimVars();
    MARK_MENU_ITEM("Options.AnimateMoving", appData.animate);
}

void
AutoflagProc ()
{
    appData.autoCallFlag = !appData.autoCallFlag;
    MARK_MENU_ITEM("Options.AutoFlag", appData.autoCallFlag);
}

void
AutoflipProc ()
{
    appData.autoFlipView = !appData.autoFlipView;
    MARK_MENU_ITEM("Options.AutoFlipView", appData.autoFlipView);
}

void
BlindfoldProc ()
{
    appData.blindfold = !appData.blindfold;
    MARK_MENU_ITEM("Options.Blindfold", appData.blindfold);
    DrawPosition(True, NULL);
}

void
TestLegalityProc ()
{
    appData.testLegality = !appData.testLegality;
    MARK_MENU_ITEM("Options.TestLegality", appData.testLegality);
}


void
FlashMovesProc ()
{
    if (appData.flashCount == 0) {
		appData.flashCount = 3;
    } else {
		appData.flashCount = -appData.flashCount;
    }
    MARK_MENU_ITEM("Options.FlashMoves", appData.flashCount > 0);
}

#if HIGHDRAG
void
HighlightDraggingProc ()
{
    appData.highlightDragging = !appData.highlightDragging;
    MARK_MENU_ITEM("Options.HighlightDragging", appData.highlightDragging);
}
#endif

void
HighlightLastMoveProc ()
{
    appData.highlightLastMove = !appData.highlightLastMove;
    MARK_MENU_ITEM("Options.HighlightLastMove", appData.highlightLastMove);
}

void
HighlightArrowProc ()
{
    appData.highlightMoveWithArrow = !appData.highlightMoveWithArrow;
    MARK_MENU_ITEM("Options.HighlightWithArrow", appData.highlightMoveWithArrow);
}

void
IcsAlarmProc ()
{
    appData.icsAlarm = !appData.icsAlarm;
	//    MARK_MENU_ITEM("Options.ICSAlarm", appData.icsAlarm);
}

void
MoveSoundProc ()
{
    appData.ringBellAfterMoves = !appData.ringBellAfterMoves;
    MARK_MENU_ITEM("Options.MoveSound", appData.ringBellAfterMoves);
}

void
OneClickProc ()
{
    appData.oneClick = !appData.oneClick;
    MARK_MENU_ITEM("Options.OneClickMoving", appData.oneClick);
}

void
PeriodicUpdatesProc ()
{
    PeriodicUpdatesEvent(!appData.periodicUpdates);
    MARK_MENU_ITEM("Options.PeriodicUpdates", appData.periodicUpdates);
}

void
PopupExitMessageProc ()
{
    appData.popupExitMessage = !appData.popupExitMessage;
    MARK_MENU_ITEM("Options.PopupExitMessage", appData.popupExitMessage);
}

void
PopupMoveErrorsProc ()
{
    appData.popupMoveErrors = !appData.popupMoveErrors;
    MARK_MENU_ITEM("Options.PopupMoveErrors", appData.popupMoveErrors);
}

void
PremoveProc ()
{
    appData.premove = !appData.premove;
	//    MARK_MENU_ITEM("Options.Premove", appData.premove);
}

void
ShowCoordsProc ()
{
    appData.showCoords = !appData.showCoords;
    MARK_MENU_ITEM("Options.ShowCoords", appData.showCoords);
    DrawPosition(True, NULL);
}

void
ShowThinkingProc ()
{
    appData.showThinking = !appData.showThinking; // [HGM] thinking: taken out of ShowThinkingEvent
    ShowThinkingEvent();
}

void
HideThinkingProc ()
{
	appData.hideThinkingFromHuman = !appData.hideThinkingFromHuman; // [HGM] thinking: taken out of ShowThinkingEvent
	ShowThinkingEvent();
	
	MARK_MENU_ITEM("Options.HideThinking", appData.hideThinkingFromHuman);
}

void
CreateBookDelayed ()
{
	ScheduleDelayedEvent(CreateBookEvent, 50);
}

/*
 *  Menu definition tables
 */
#if 0
MenuItem fileMenu[] = {
	{N_("New Game"),             "<Ctrl>n",          "NewGame",              ResetGameEvent},
	{N_("New Shuffle Game ..."),  NULL,              "NewShuffleGame",       ShuffleMenuProc},
	{N_("New Variant ..."),      "<Alt><Shift>v",    "NewVariant",           NewVariantProc},// [HGM] variant: not functional yet
	{"----",                      NULL,               NULL,                  NothingProc},
	{N_("Load Game"),            "<Ctrl>o",          "LoadGame",             LoadGameProc,           CHECK},
	{N_("Load Position"),        "<Ctrl><Shift>o",   "LoadPosition",         LoadPositionProc},
	{N_("Next Position"),        "<Shift>Page_Down", "LoadNextPosition",     LoadNextPositionProc},
	{N_("Prev Position"),        "<Shift>Page_Up",   "LoadPreviousPosition", LoadPrevPositionProc},
	{"----",                      NULL,               NULL,                  NothingProc},
	{N_("Save Game"),            "<Ctrl>s",          "SaveGame",             SaveGameProc},
	{N_("Save Position"),        "<Ctrl><Shift>s",   "SavePosition",         SavePositionProc},
	{N_("Save Games as Book"),    NULL,              "CreateBook",           CreateBookDelayed},
	{"----",                      NULL,               NULL,                  NothingProc},
	{N_("Mail Move"),             NULL,              "MailMove",             MailMoveEvent},
	{N_("Reload CMail Message"),  NULL,              "ReloadCMailMessage",   ReloadCmailMsgProc},
	{"----",                      NULL,               NULL,                  NothingProc},
	{N_("Quit "),                "<Ctrl>q",          "Quit",                 QuitProc},
	{NULL,                        NULL,               NULL,                  NULL}
};

MenuItem editMenu[] = {
	{N_("Copy Game"),      "<Ctrl>c",        "CopyGame",      CopyGameProc},
	{N_("Copy Position"),  "<Ctrl><Shift>c", "CopyPosition",  CopyPositionProc},
	{N_("Copy Game List"),  NULL,            "CopyGameList",  CopyGameListProc},
	{"----",                NULL,             NULL,           NothingProc},
	{N_("Paste Game"),     "<Ctrl>v",        "PasteGame",     PasteGameProc},
	{N_("Paste Position"), "<Ctrl><Shift>v", "PastePosition", PastePositionProc},
	{"----",                NULL,             NULL,           NothingProc},
	{N_("Edit Game"),      "<Ctrl>e",        "EditGame",      EditGameEvent},
	{N_("Edit Position"),  "<Ctrl><Shift>e", "EditPosition",  EditPositionEvent},
	{N_("Edit Tags"),       NULL,            "EditTags",      EditTagsProc},
	{N_("Edit Comment"),    NULL,            "EditComment",   EditCommentProc},
	{N_("Edit Book"),       NULL,            "EditBook",      EditBookEvent},
	{"----",                NULL,             NULL,           NothingProc},
	{N_("Revert"),         "Home",           "Revert",        RevertProc},
	{N_("Annotate"),        NULL,            "Annotate",      AnnotateProc},
	{N_("Truncate Game"),  "End",            "TruncateGame",  TruncateGameEvent},
	{"----",                NULL,             NULL,           NothingProc},
	{N_("Backward"),       "<Alt>Left",      "Backward",      BackwardEvent},
	{N_("Forward"),        "<Alt>Right",     "Forward",       ForwardEvent},
	{N_("Back to Start"),  "<Alt>Home",      "BacktoStart",   ToStartEvent},
	{N_("Forward to End"), "<Alt>End",       "ForwardtoEnd",  ToEndEvent},
	{NULL,                  NULL,             NULL,	    NULL}
};

MenuItem viewMenu[] = {
	{N_("Flip View"),         "F2",            "FlipView",        FlipViewProc,           CHECK},
	{"----",                   NULL,            NULL,             NothingProc},
	{N_("Engine Output"),     "<Alt><Shift>o", "EngineOutput",    EngineOutputProc,       CHECK},
	{N_("Move History"),      "<Alt><Shift>h", "MoveHistory",     HistoryShowProc,        CHECK}, // [HGM] hist: activate 4.2.7 code
	{N_("Evaluation Graph"),  "<Alt><Shift>e", "EvaluationGraph", EvalGraphProc,          CHECK},
	{N_("Game List"),         "<Alt><Shift>g", "GameList",        ShowGameListProc,       CHECK},
	{N_("ICS text menu"),      NULL,           "ICStextmenu",     IcsTextProc,            CHECK},
	{"----",                   NULL,            NULL,             NothingProc},
	{N_("Tags"),               NULL,           "Tags",            EditTagsProc,           CHECK},
	{N_("Comments"),           NULL,           "Comments",        EditCommentProc,        CHECK},
	{N_("ICS Input Box"),      NULL,           "ICSInputBox",     IcsInputBoxProc,        CHECK},
	{N_("Open Chat Window"),   NULL,           "OpenChatWindow",  ChatProc,               CHECK},
	{"----",                   NULL,            NULL,             NothingProc},
	{N_("Board..."),           NULL,           "Board",           BoardOptionsProc},
	{N_("Game List Tags..."),  NULL,           "GameListTags",    GameListOptionsProc},
	{NULL,                     NULL,            NULL,             NULL}
};

MenuItem modeMenu[] = {
	{N_("Machine White"),  "<Ctrl>w",        "MachineWhite",  MachineWhiteEvent,              RADIO },
	{N_("Machine Black"),  "<Ctrl>b",        "MachineBlack",  MachineBlackEvent,              RADIO },
	{N_("Two Machines"),   "<Ctrl>t",        "TwoMachines",   TwoMachinesEvent,               RADIO },
	{N_("Analysis Mode"),  "<Ctrl>a",        "AnalysisMode",  (MenuProc*) AnalyzeModeEvent,   RADIO },
	{N_("Analyze Game"),   "<Ctrl>g",        "AnalyzeFile",   AnalyzeFileEvent,               RADIO },
	{N_("Edit Game"),      "<Ctrl>e",        "EditGame",      EditGameEvent,                  RADIO },
	{N_("Edit Position"),  "<Ctrl><Shift>e", "EditPosition",  EditPositionEvent,              RADIO },
	{N_("Training"),        NULL,            "Training",      TrainingEvent,                  RADIO },
	{N_("ICS Client"),      NULL,            "ICSClient",     IcsClientEvent,                 RADIO },
	{"----",                NULL,             NULL,           NothingProc},
	{N_("Machine Match"),   NULL,            "MachineMatch",  MatchProc,                      CHECK },
	{N_("Pause"),          "Pause",          "Pause",         PauseEvent,                     CHECK },
	{NULL,                  NULL,             NULL,           NULL}
};

MenuItem actionMenu[] = {
	{N_("Accept"),             "F3",   "Accept",             AcceptEvent},
	{N_("Decline"),            "F4",   "Decline",            DeclineEvent},
	{N_("Rematch"),            "F12",  "Rematch",            RematchEvent},
	{"----",                    NULL,   NULL,                NothingProc},
	{N_("Call Flag"),          "F5",   "CallFlag",           CallFlagEvent},
	{N_("Draw"),               "F6",   "Draw",               DrawEvent},
	{N_("Adjourn"),            "F7",   "Adjourn",            AdjournEvent},
	{N_("Abort"),              "F8",   "Abort",              AbortEvent},
	{N_("Resign"),             "F9",   "Resign",             ResignEvent},
	{"----",                    NULL,   NULL,                NothingProc},
	{N_("Stop Observing"),     "F10",  "StopObserving",      StopObservingEvent},
	{N_("Stop Examining"),     "F11",  "StopExamining",      StopExaminingEvent},
	{N_("Upload to Examine"),   NULL,  "UploadtoExamine",    UploadGameEvent},
	{"----",                    NULL,   NULL,                NothingProc},
	{N_("Adjudicate to White"), NULL,  "AdjudicatetoWhite",  AdjuWhiteProc},
	{N_("Adjudicate to Black"), NULL,  "AdjudicatetoBlack",  AdjuBlackProc},
	{N_("Adjudicate Draw"),     NULL,  "AdjudicateDraw",     AdjuDrawProc},
	{NULL,                      NULL,   NULL,		   NULL}
};

MenuItem engineMenu[100] = {
	{N_("Load New 1st Engine ..."),  NULL,     "LoadNew1stEngine", LoadEngine1Proc},
	{N_("Load New 2nd Engine ..."),  NULL,     "LoadNew2ndEngine", LoadEngine2Proc},
	{"----",                         NULL,      NULL,              NothingProc},
	{N_("Engine #1 Settings ..."),   NULL,     "Engine#1Settings", FirstSettingsProc},
	{N_("Engine #2 Settings ..."),   NULL,     "Engine#2Settings", SecondSettingsProc},
	{"----",                         NULL,      NULL,              NothingProc},
	{N_("Hint"),                     NULL,     "Hint",             HintEvent},
	{N_("Book"),                     NULL,     "Book",             BookEvent},
	{"----",                         NULL,      NULL,              NothingProc},
	{N_("Move Now"),                "<Ctrl>m", "MoveNow",          MoveNowEvent},
	{N_("Retract Move"),            "<Ctrl>x", "RetractMove",      RetractMoveEvent},
	{NULL,                           NULL,      NULL,              NULL}
};

MenuItem optionsMenu[] = {
#ifdef OPTIONSDIALOG
	{N_("General ..."),             NULL,             "General",             OptionsProc},
#endif
	{N_("Time Control ..."),       "<Alt><Shift>t",   "TimeControl",         TimeControlProc},
	{N_("Common Engine ..."),      "<Alt><Shift>u",   "CommonEngine",        UciMenuProc},
	{N_("Adjudications ..."),      "<Alt><Shift>j",   "Adjudications",       EngineMenuProc},
	{N_("ICS ..."),                 NULL,             "ICS",                 IcsOptionsProc},
	{N_("Match ..."),               NULL,             "Match",               MatchOptionsProc},
	{N_("Load Game ..."),           NULL,             "LoadGame",            LoadOptionsProc},
	{N_("Save Game ..."),           NULL,             "SaveGame",            SaveOptionsProc},
	{N_("Game List ..."),           NULL,             "GameList",            GameListOptionsProc},
	{N_("Sounds ..."),              NULL,             "Sounds",              SoundOptionsProc},
	{"----",                        NULL,              NULL,                 NothingProc},
#ifndef OPTIONSDIALOG
	{N_("Always Queen"),           "<Ctrl><Shift>q",  "AlwaysQueen",         AlwaysQueenProc},
	{N_("Animate Dragging"),        NULL,             "AnimateDragging",     AnimateDraggingProc},
	{N_("Animate Moving"),         "<Ctrl><Shift>a",  "AnimateMoving",       AnimateMovingProc},
	{N_("Auto Flag"),              "<Ctrl><Shift>f",  "AutoFlag",            AutoflagProc},
	{N_("Auto Flip View"),          NULL,             "AutoFlipView",        AutoflipProc},
	{N_("Blindfold"),               NULL,             "Blindfold",           BlindfoldProc},
	{N_("Flash Moves"),             NULL,             "FlashMoves",          FlashMovesProc},
#if HIGHDRAG
	{N_("Highlight Dragging"),      NULL,             "HighlightDragging",   HighlightDraggingProc},
#endif
	{N_("Highlight Last Move"),     NULL,             "HighlightLastMove",   HighlightLastMoveProc},
	{N_("Highlight With Arrow"),    NULL,             "HighlightWithArrow",  HighlightArrowProc},
	{N_("Move Sound"),              NULL,             "MoveSound",           MoveSoundProc},
	{N_("One-Click Moving"),        NULL,             "OneClickMoving",      OneClickProc},
	{N_("Periodic Updates"),        NULL,             "PeriodicUpdates",     PeriodicUpdatesProc},
	{N_("Ponder Next Move"),       "<Ctrl><Shift>p",  "PonderNextMove",      PonderNextMoveProc},
	{N_("Popup Exit Message"),      NULL,             "PopupExitMessage",    PopupExitMessageProc},
	{N_("Popup Move Errors"),       NULL,             "PopupMoveErrors",     PopupMoveErrorsProc},
	{N_("Show Coords"),             NULL,             "ShowCoords",          ShowCoordsProc},
	{N_("Hide Thinking"),          "<Ctrl><Shift>h",  "HideThinking",        HideThinkingProc},
	{N_("Test Legality"),          "<Ctrl><Shift>l",  "TestLegality",        TestLegalityProc},
	{"----",                        NULL,              NULL,                 NothingProc},
#endif
	{N_("Save Settings Now"),       NULL,             "SaveSettingsNow",     SaveSettingsProc},
	{N_("Save Settings on Exit"),   NULL,             "SaveSettingsonExit",  SaveOnExitProc,         CHECK },
	{NULL,                          NULL,              NULL,                 NULL}
};

MenuItem helpMenu[] = {
	{N_("Info XBoard"),		 NULL,	 "InfoXBoard",	         InfoProc},
	{N_("Man XBoard"),		"F1",	 "ManXBoard",		 ManProc},
	{"----",			 NULL,	  NULL,			 NothingProc},
	{N_("XBoard Home Page"),	 NULL,	 "XBoardHomePage",	 HomePageProc},
	{N_("On-line User Guide"),	 NULL,	 "On-lineUserGuide",	 GuideProc},
	{N_("Development News"),	 NULL,	 "DevelopmentNews",	 NewsPageProc},
	{N_("e-Mail Bug Report"),	 NULL,	 "e-MailBugReport",	 BugReportProc},
	{"----",			 NULL,	  NULL,			 NothingProc},
	{N_("About XBoard"),		 NULL,	 "AboutXBoard",		 AboutProc},
	{NULL,			 NULL,    NULL,			 NULL}
};

MenuItem noMenu[] = {
	{ "", "<Alt>Next" ,"LoadNextGame", LoadNextGameProc },
	{ "", "<Alt>Prior" ,"LoadPrevGame", LoadPrevGameProc },
	{ "", NULL,"ReloadGame", ReloadGameProc },
	{ "", NULL,"ReloadPosition", ReloadPositionProc },
#ifndef OPTIONSDIALOG
	{ "", NULL,"AlwaysQueen", AlwaysQueenProc },
	{ "", NULL,"AnimateDragging", AnimateDraggingProc },
	{ "", NULL,"AnimateMoving", AnimateMovingProc },
	{ "", NULL,"Autoflag", AutoflagProc },
	{ "", NULL,"Autoflip", AutoflipProc },
	{ "", NULL,"Blindfold", BlindfoldProc },
	{ "", NULL,"FlashMoves", FlashMovesProc },
#if HIGHDRAG
	{ "", NULL,"HighlightDragging", HighlightDraggingProc },
#endif
	{ "", NULL,"HighlightLastMove", HighlightLastMoveProc },
	{ "", NULL,"MoveSound", MoveSoundProc },
	{ "", NULL,"PeriodicUpdates", PeriodicUpdatesProc },
	{ "", NULL,"PopupExitMessage", PopupExitMessageProc },
	{ "", NULL,"PopupMoveErrors", PopupMoveErrorsProc },
	{ "", NULL,"ShowCoords", ShowCoordsProc },
	{ "", NULL,"ShowThinking", ShowThinkingProc },
	{ "", NULL,"HideThinking", HideThinkingProc },
	{ "", NULL,"TestLegality", TestLegalityProc },
#endif
	{ "", NULL,"AboutGame", AboutGameEvent },
	{ "", "<Ctrl>d" ,"DebugProc", DebugProc },
	{ "", NULL,"Nothing", NothingProc },
	{NULL, NULL, NULL, NULL}
};

Menu menuBar[] = {
    {N_("File"),    "File", fileMenu},
    {N_("Edit"),    "Edit", editMenu},
    {N_("View"),    "View", viewMenu},
    {N_("Mode"),    "Mode", modeMenu},
    {N_("Action"),  "Action", actionMenu},
    {N_("Engine"),  "Engine", engineMenu},
    {N_("Options"), "Options", optionsMenu},
    {N_("Help"),    "Help", helpMenu},
    {NULL, NULL, NULL}
};
#endif

MenuItem *
MenuNameToItem (char *menuName)
{
    int i=0;
    char buf[MSG_SIZ], *p;
    MenuItem *menuTab;
    static MenuItem a = { NULL, NULL, NULL, NothingProc };
    extern Option mainOptions[];
    safeStrCpy(buf, menuName, MSG_SIZ);
    p = strchr(buf, '.');
    /*if(!p) menuTab = noMenu, p = menuName; else */{
		*p++ = NULLCHAR;
		for(i=0; menuBar[i].name; i++)
			if(!strcmp(buf, menuBar[i].name)) break;
		if(!menuBar[i].name) return NULL; // main menu not found
		menuTab = menuBar[i].mi;
    }
    if(*p == NULLCHAR) { a.handle = mainOptions[i+1].handle; return &a; } // main menu bar
    for(i=0; menuTab[i].string; i++)
		if(menuTab[i].ref && !strcmp(p, menuTab[i].ref)) return menuTab + i;
    return NULL; // item not found
}

//int firstEngineItem;

void AppendEnginesToMenu(char *list)
{
    int i=0;
    char *p;
    if(appData.icsActive || appData.recentEngines <= 0) return;
    //for(firstEngineItem=0; engineMenu[firstEngineItem].string; firstEngineItem++);
    recentEngines = strdup(list);
    while (*list) {
		p = strchr(list, '\n');
		if(p == NULL)
			break;
		*p = 0;
		[[NSApp delegate] addEngineToMenu:@(list)];
		//if(firstEngineItem + i < 99)
		//	engineMenu[firstEngineItem+i].string = strdup(list); // just set name; MenuProc stays NULL
		i++;
		*p = '\n';
		list = p + 1;
    }
}

Enables icsEnables[] = {
    { "File.MailMove", False },
    { "File.ReloadCMailMessage", False },
    { "Mode.MachineBlack", False },
    { "Mode.MachineWhite", False },
    { "Mode.AnalysisMode", False },
    { "Mode.AnalyzeFile", False },
    { "Mode.TwoMachines", False },
    { "Mode.MachineMatch", False },
#if !ZIPPY
    { "Engine.Hint", False },
    { "Engine.Book", False },
    { "Engine.MoveNow", False },
#ifndef OPTIONSDIALOG
    { "PeriodicUpdates", False },
    { "HideThinking", False },
    { "PonderNextMove", False },
#endif
#endif
    { "Engine.Engine#1Settings", False },
    { "Engine.Engine#2Settings", False },
    { "Engine.Load1stEngine", False },
    { "Engine.Load2ndEngine", False },
    { "Edit.Annotate", False },
    { "Options.Match", False },
    { NULL, False }
};

Enables ncpEnables[] = {
    { "File.MailMove", False },
    { "File.ReloadCMailMessage", False },
    { "Mode.MachineWhite", False },
    { "Mode.MachineBlack", False },
    { "Mode.AnalysisMode", False },
    { "Mode.AnalyzeFile", False },
    { "Mode.TwoMachines", False },
    { "Mode.MachineMatch", False },
    { "Mode.ICSClient", False },
    { "View.ICStextmenu", False },
    { "View.ICSInputBox", False },
    { "View.OpenChatWindow", False },
    { "Action.", False },
    { "Edit.Revert", False },
    { "Edit.Annotate", False },
    { "Engine.Engine#1Settings", False },
    { "Engine.Engine#2Settings", False },
    { "Engine.MoveNow", False },
    { "Engine.RetractMove", False },
    { "Options.ICS", False },
#ifndef OPTIONSDIALOG
    { "Options.AutoFlag", False },
    { "Options.AutoFlip View", False },
	//    { "Options.ICSAlarm", False },
    { "Options.MoveSound", False },
    { "Options.HideThinking", False },
    { "Options.PeriodicUpdates", False },
    { "Options.PonderNextMove", False },
#endif
    { "Engine.Hint", False },
    { "Engine.Book", False },
    { NULL, False }
};

Enables gnuEnables[] = {
    { "Mode.ICSClient", False },
    { "View.ICStextmenu", False },
    { "View.ICSInputBox", False },
    { "View.OpenChatWindow", False },
    { "Action.Accept", False },
    { "Action.Decline", False },
    { "Action.Rematch", False },
    { "Action.Adjourn", False },
    { "Action.StopExamining", False },
    { "Action.StopObserving", False },
    { "Action.UploadtoExamine", False },
    { "Edit.Revert", False },
    { "Edit.Annotate", False },
    { "Options.ICS", False },
	
    /* The next two options rely on SetCmailMode being called *after*    */
    /* SetGNUMode so that when GNU is being used to give hints these     */
    /* menu options are still available                                  */
	
    { "File.MailMove", False },
    { "File.ReloadCMailMessage", False },
    // [HGM] The following have been added to make a switch from ncp to GNU mode possible
    { "Mode.MachineWhite", True },
    { "Mode.MachineBlack", True },
    { "Mode.AnalysisMode", True },
    { "Mode.AnalyzeFile", True },
    { "Mode.TwoMachines", True },
    { "Mode.MachineMatch", True },
    { "Engine.Engine#1Settings", True },
    { "Engine.Engine#2Settings", True },
    { "Engine.Hint", True },
    { "Engine.Book", True },
    { "Engine.MoveNow", True },
    { "Engine.RetractMove", True },
    { "Action.", True },
    { NULL, False }
};

Enables cmailEnables[] = {
    { "Action.", True },
    { "Action.CallFlag", False },
    { "Action.Draw", True },
    { "Action.Adjourn", False },
    { "Action.Abort", False },
    { "Action.StopObserving", False },
    { "Action.StopExamining", False },
    { "File.MailMove", True },
    { "File.ReloadCMailMessage", True },
    { NULL, False }
};

Enables trainingOnEnables[] = {
	{ "Edit.EditComment", False },
	{ "Mode.Pause", False },
	{ "Edit.Forward", False },
	{ "Edit.Backward", False },
	{ "Edit.ForwardtoEnd", False },
	{ "Edit.BacktoStart", False },
	{ "Engine.MoveNow", False },
	{ "Edit.TruncateGame", False },
	{ NULL, False }
};

Enables trainingOffEnables[] = {
	{ "Edit.EditComment", True },
	{ "Mode.Pause", True },
	{ "Edit.Forward", True },
	{ "Edit.Backward", True },
	{ "Edit.ForwardtoEnd", True },
	{ "Edit.BacktoStart", True },
	{ "Engine.MoveNow", True },
	{ "Engine.TruncateGame", True },
	{ NULL, False }
};

Enables machineThinkingEnables[] = {
	{ "File.LoadGame", False },
	//  { "LoadNextGame", False },
	//  { "LoadPreviousGame", False },
	//  { "ReloadSameGame", False },
	{ "Edit.PasteGame", False },
	{ "File.LoadPosition", False },
	//  { "LoadNextPosition", False },
	//  { "LoadPreviousPosition", False },
	//  { "ReloadSamePosition", False },
	{ "Edit.PastePosition", False },
	{ "Mode.MachineWhite", False },
	{ "Mode.MachineBlack", False },
	{ "Mode.TwoMachines", False },
	//  { "MachineMatch", False },
	{ "Engine.RetractMove", False },
	{ NULL, False }
};

Enables userThinkingEnables[] = {
	{ "File.LoadGame", True },
	//  { "LoadNextGame", True },
	//  { "LoadPreviousGame", True },
	//  { "ReloadSameGame", True },
	{ "Edit.PasteGame", True },
	{ "File.LoadPosition", True },
	//  { "LoadNextPosition", True },
	//  { "LoadPreviousPosition", True },
	//  { "ReloadSamePosition", True },
	{ "Edit.PastePosition", True },
	{ "Mode.MachineWhite", True },
	{ "Mode.MachineBlack", True },
	{ "Mode.TwoMachines", True },
	//  { "MachineMatch", True },
	{ "Engine.RetractMove", True },
	{ NULL, False }
};

void
SetICSMode ()
{
	SetMenuEnables(icsEnables);
	
#if ZIPPY
	if (appData.zippyPlay && !appData.noChessProgram) { /* [DM] icsEngineAnalyze */
		EnableNamedMenuItem("Mode.AnalysisMode", True);
		EnableNamedMenuItem("Engine.Engine#1Settings", True);
	}
#endif
}

void
SetNCPMode ()
{
	SetMenuEnables(ncpEnables);
}

void
SetGNUMode ()
{
	SetMenuEnables(gnuEnables);
}

void
SetCmailMode ()
{
	SetMenuEnables(cmailEnables);
}

void
SetTrainingModeOn ()
{
	SetMenuEnables(trainingOnEnables);
	if (appData.showButtonBar) {
		EnableButtonBar(False);
	}
	CommentPopDown();
}

void
SetTrainingModeOff ()
{
	SetMenuEnables(trainingOffEnables);
	if (appData.showButtonBar) {
		EnableButtonBar(True);
	}
}

void
SetUserThinkingEnables ()
{
	if (appData.noChessProgram) return;
	SetMenuEnables(userThinkingEnables);
}

void
SetMachineThinkingEnables ()
{
	if (appData.noChessProgram) return;
	SetMenuEnables(machineThinkingEnables);
	switch (gameMode) {
		case MachinePlaysBlack:
		case MachinePlaysWhite:
		case TwoMachinesPlay:
			EnableNamedMenuItem(ModeToWidgetName(gameMode), True);
			break;
		default:
			break;
	}
}

void
GreyRevert (Boolean grey)
{
    EnableNamedMenuItem("Edit.Revert", !grey);
    EnableNamedMenuItem("Edit.Annotate", !grey);
}

char *
ModeToWidgetName (GameMode mode)
{
    switch (mode) {
		case BeginningOfGame:
			if (appData.icsActive)
				return "Mode.ICSClient";
			else if (appData.noChessProgram ||
					 *appData.cmailGameName != NULLCHAR)
				return "Mode.EditGame";
			else
				return "Mode.MachineBlack";
		case MachinePlaysBlack:
			return "Mode.MachineBlack";
		case MachinePlaysWhite:
			return "Mode.MachineWhite";
		case AnalyzeMode:
			return "Mode.AnalysisMode";
		case AnalyzeFile:
			return "Mode.AnalyzeFile";
		case TwoMachinesPlay:
			return "Mode.TwoMachines";
		case EditGame:
			return "Mode.EditGame";
		case PlayFromGameFile:
			return "File.LoadGame";
		case EditPosition:
			return "Mode.EditPosition";
		case Training:
			return "Mode.Training";
		case IcsPlayingWhite:
		case IcsPlayingBlack:
		case IcsObserving:
		case IcsIdle:
		case IcsExamining:
			return "Mode.ICSClient";
		default:
		case EndOfGame:
			return NULL;
    }
}

void
InitMenuMarkers()
{
#ifndef OPTIONSDIALOG
    if (appData.alwaysPromoteToQueen) {
		MarkMenuItem("Options.Always Queen", True);
    }
    if (appData.animateDragging) {
		MarkMenuItem("Options.Animate Dragging", True);
    }
    if (appData.animate) {
		MarkMenuItem("Options.Animate Moving", True);
    }
    if (appData.autoCallFlag) {
		MarkMenuItem("Options.Auto Flag", True);
    }
    if (appData.autoFlipView) {
		XtSetValues(XtNameToWidget(menuBarWidget,"Options.Auto Flip View", True);
					}
					if (appData.blindfold) {
						MarkMenuItem("Options.Blindfold", True);
					}
					if (appData.flashCount > 0) {
						MarkMenuItem("Options.Flash Moves", True);
					}
#if HIGHDRAG
					if (appData.highlightDragging) {
						MarkMenuItem("Options.Highlight Dragging", True);
					}
#endif
					if (appData.highlightLastMove) {
						MarkMenuItem("Options.Highlight Last Move", True);
					}
					if (appData.highlightMoveWithArrow) {
						MarkMenuItem("Options.Arrow", True);
					}
					//    if (appData.icsAlarm) {
					//	MarkMenuItem("Options.ICS Alarm", True);
					//    }
					if (appData.ringBellAfterMoves) {
						MarkMenuItem("Options.Move Sound", True);
					}
					if (appData.oneClick) {
						MarkMenuItem("Options.OneClick", True);
					}
					if (appData.periodicUpdates) {
						MarkMenuItem("Options.Periodic Updates", True);
					}
					if (appData.ponderNextMove) {
						MarkMenuItem("Options.Ponder Next Move", True);
					}
					if (appData.popupExitMessage) {
						MarkMenuItem("Options.Popup Exit Message", True);
					}
					if (appData.popupMoveErrors) {
						MarkMenuItem("Options.Popup Move Errors", True);
					}
					//    if (appData.premove) {
					//	MarkMenuItem("Options.Premove", True);
					//    }
					if (appData.showCoords) {
						MarkMenuItem("Options.Show Coords", True);
					}
					if (appData.hideThinkingFromHuman) {
						MarkMenuItem("Options.Hide Thinking", True);
					}
					if (appData.testLegality) {
						MarkMenuItem("Options.Test Legality", True);
					}
#endif
					if (saveSettingsOnExit) {
						MarkMenuItem("Options.SaveSettingsonExit", True);
					}
					}

