/* cleaned for luaswig */
/*
    SDL - Simple DirectMedia Layer
    Copyright (C) 1997, 1998, 1999, 2000, 2001  Sam Lantinga

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Library General Public
    License as published by the Free Software Foundation; either
    version 2 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Library General Public License for more details.

    You should have received a copy of the GNU Library General Public
    License along with this library; if not, write to the Free
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    Sam Lantinga
    slouken@devolution.com
*/

%module luaSDL

%{
#include <SDL/SDL.h>

#ifdef NO_GLIB
#define g_malloc malloc
#endif /* NO_GLIB */
%}


/* some utility bitwise operations */
%inline %{
	int	bit_or(int a, int b)
	{
		return a | b;
	}

	int	bit_and(int a, int b)
	{
		return a & b;
	}

	int	bit_not(int a)
	{
		return ~a;
	}

	int	bit_xor(int a, int b)
	{
		return a ^ b;
	}
%}


/* Main include header for the SDL library */

/* Basic data types */
typedef enum {
	SDL_FALSE = 0,
	SDL_TRUE  = 1
} SDL_bool;
typedef unsigned char	Uint8;
typedef signed char	Sint8;
typedef unsigned short	Uint16;
typedef signed short	Sint16;
typedef unsigned int	Uint32;
typedef signed int	Sint32;


/* General keyboard/mouse state definitions */
enum { SDL_PRESSED = 0x01, SDL_RELEASED = 0x00 };


/* Public functions */
// not for luaswig:  extern void SDL_SetError(const char *fmt);
extern char * SDL_GetError(void);
extern void SDL_ClearError(void);


/* This is the OS scheduler timeslice, in milliseconds */
#define SDL_TIMESLICE		10

/* This is the maximum resolution of the SDL timer on all platforms */
#define TIMER_RESOLUTION	10	/* Experimentally determined */

/* Get the number of milliseconds since the SDL library initialization.
 * Note that this value wraps if the program runs for more than ~49 days.
 */ 
extern Uint32 SDL_GetTicks(void);

/* Wait a specified number of milliseconds before returning */
extern void SDL_Delay(Uint32 ms);


/* In order to use these functions, SDL_Init() must have been called
   with the SDL_INIT_JOYSTICK flag.  This causes SDL to scan the system
   for joysticks, and load appropriate drivers.
*/

/* The joystick structure used to identify an SDL joystick */
typedef struct SDL_Joystick {
} SDL_Joystick;


/* Function prototypes */
/*
 * Count the number of joysticks attached to the system
 */
extern int SDL_NumJoysticks(void);

/*
 * Get the implementation dependent name of a joystick.
 * This can be called before any joysticks are opened.
 * If no name can be found, this function returns NULL.
 */
extern const char *SDL_JoystickName(int device_index);

/*
 * Open a joystick for use - the index passed as an argument refers to
 * the N'th joystick on the system.  This index is the value which will
 * identify this joystick in future joystick events.
 *
 * This function returns a joystick identifier, or NULL if an error occurred.
 */
extern SDL_Joystick *SDL_JoystickOpen(int device_index);

/*
 * Returns 1 if the joystick has been opened, or 0 if it has not.
 */
extern int SDL_JoystickOpened(int device_index);

/*
 * Get the device index of an opened joystick.
 */
extern int SDL_JoystickIndex(SDL_Joystick *joystick);

/*
 * Get the number of general axis controls on a joystick
 */
extern int SDL_JoystickNumAxes(SDL_Joystick *joystick);

/*
 * Get the number of trackballs on a joystick
 * Joystick trackballs have only relative motion events associated
 * with them and their state cannot be polled.
 */
extern int SDL_JoystickNumBalls(SDL_Joystick *joystick);

/*
 * Get the number of POV hats on a joystick
 */
extern int SDL_JoystickNumHats(SDL_Joystick *joystick);

/*
 * Get the number of buttons on a joystick
 */
extern int SDL_JoystickNumButtons(SDL_Joystick *joystick);

/*
 * Update the current state of the open joysticks.
 * This is called automatically by the event loop if any joystick
 * events are enabled.
 */
extern void SDL_JoystickUpdate(void);

/*
 * Enable/disable joystick event polling.
 * If joystick events are disabled, you must call SDL_JoystickUpdate()
 * yourself and check the state of the joystick when you want joystick
 * information.
 * The state can be one of SDL_QUERY, SDL_ENABLE or SDL_IGNORE.
 */
extern int SDL_JoystickEventState(int state);

/*
 * Get the current state of an axis control on a joystick
 * The state is a value ranging from -32768 to 32767.
 * The axis indices start at index 0.
 */
extern Sint16 SDL_JoystickGetAxis(SDL_Joystick *joystick, int axis);

/*
 * Get the current state of a POV hat on a joystick
 * The return value is one of the following positions:
 */
#define SDL_HAT_CENTERED	0x00
#define SDL_HAT_UP		0x01
#define SDL_HAT_RIGHT		0x02
#define SDL_HAT_DOWN		0x04
#define SDL_HAT_LEFT		0x08
#define SDL_HAT_RIGHTUP		(SDL_HAT_RIGHT|SDL_HAT_UP)
#define SDL_HAT_RIGHTDOWN	(SDL_HAT_RIGHT|SDL_HAT_DOWN)
#define SDL_HAT_LEFTUP		(SDL_HAT_LEFT|SDL_HAT_UP)
#define SDL_HAT_LEFTDOWN	(SDL_HAT_LEFT|SDL_HAT_DOWN)
/*
 * The hat indices start at index 0.
 */
extern Uint8 SDL_JoystickGetHat(SDL_Joystick *joystick, int hat);

/*
 * Get the ball axis change since the last poll
 * This returns 0, or -1 if you passed it invalid parameters.
 * The ball indices start at index 0.
 */
extern int SDL_JoystickGetBall(SDL_Joystick *joystick, int ball, int *dx, int *dy);

/*
 * Get the current state of a button on a joystick
 * The button indices start at index 0.
 */
extern Uint8 SDL_JoystickGetButton(SDL_Joystick *joystick, int button);

/*
 * Close a joystick previously opened with SDL_JoystickOpen()
 */
extern void SDL_JoystickClose(SDL_Joystick *joystick);






/* What we really want is a mapping of every raw key on the keyboard.
   To support international keyboards, we use the range 0xA1 - 0xFF
   as international virtual keycodes.  We'll follow in the footsteps of X11...
   The names of the keys
 */
 
typedef enum {
	/* The keyboard syms have been cleverly chosen to map to ASCII */
	SDLK_UNKNOWN		= 0,
	SDLK_FIRST		= 0,
	SDLK_BACKSPACE		= 8,
	SDLK_TAB		= 9,
	SDLK_CLEAR		= 12,
	SDLK_RETURN		= 13,
	SDLK_PAUSE		= 19,
	SDLK_ESCAPE		= 27,
	SDLK_SPACE		= 32,
	SDLK_EXCLAIM		= 33,
	SDLK_QUOTEDBL		= 34,
	SDLK_HASH		= 35,
	SDLK_DOLLAR		= 36,
	SDLK_AMPERSAND		= 38,
	SDLK_QUOTE		= 39,
	SDLK_LEFTPAREN		= 40,
	SDLK_RIGHTPAREN		= 41,
	SDLK_ASTERISK		= 42,
	SDLK_PLUS		= 43,
	SDLK_COMMA		= 44,
	SDLK_MINUS		= 45,
	SDLK_PERIOD		= 46,
	SDLK_SLASH		= 47,
	SDLK_0			= 48,
	SDLK_1			= 49,
	SDLK_2			= 50,
	SDLK_3			= 51,
	SDLK_4			= 52,
	SDLK_5			= 53,
	SDLK_6			= 54,
	SDLK_7			= 55,
	SDLK_8			= 56,
	SDLK_9			= 57,
	SDLK_COLON		= 58,
	SDLK_SEMICOLON		= 59,
	SDLK_LESS		= 60,
	SDLK_EQUALS		= 61,
	SDLK_GREATER		= 62,
	SDLK_QUESTION		= 63,
	SDLK_AT			= 64,
	/* 
	   Skip uppercase letters
	 */
	SDLK_LEFTBRACKET	= 91,
	SDLK_BACKSLASH		= 92,
	SDLK_RIGHTBRACKET	= 93,
	SDLK_CARET		= 94,
	SDLK_UNDERSCORE		= 95,
	SDLK_BACKQUOTE		= 96,
	SDLK_a			= 97,
	SDLK_b			= 98,
	SDLK_c			= 99,
	SDLK_d			= 100,
	SDLK_e			= 101,
	SDLK_f			= 102,
	SDLK_g			= 103,
	SDLK_h			= 104,
	SDLK_i			= 105,
	SDLK_j			= 106,
	SDLK_k			= 107,
	SDLK_l			= 108,
	SDLK_m			= 109,
	SDLK_n			= 110,
	SDLK_o			= 111,
	SDLK_p			= 112,
	SDLK_q			= 113,
	SDLK_r			= 114,
	SDLK_s			= 115,
	SDLK_t			= 116,
	SDLK_u			= 117,
	SDLK_v			= 118,
	SDLK_w			= 119,
	SDLK_x			= 120,
	SDLK_y			= 121,
	SDLK_z			= 122,
	SDLK_DELETE		= 127,
	/* End of ASCII mapped keysyms */

	/* International keyboard syms */
	SDLK_WORLD_0		= 160,		/* 0xA0 */
	SDLK_WORLD_1		= 161,
	SDLK_WORLD_2		= 162,
	SDLK_WORLD_3		= 163,
	SDLK_WORLD_4		= 164,
	SDLK_WORLD_5		= 165,
	SDLK_WORLD_6		= 166,
	SDLK_WORLD_7		= 167,
	SDLK_WORLD_8		= 168,
	SDLK_WORLD_9		= 169,
	SDLK_WORLD_10		= 170,
	SDLK_WORLD_11		= 171,
	SDLK_WORLD_12		= 172,
	SDLK_WORLD_13		= 173,
	SDLK_WORLD_14		= 174,
	SDLK_WORLD_15		= 175,
	SDLK_WORLD_16		= 176,
	SDLK_WORLD_17		= 177,
	SDLK_WORLD_18		= 178,
	SDLK_WORLD_19		= 179,
	SDLK_WORLD_20		= 180,
	SDLK_WORLD_21		= 181,
	SDLK_WORLD_22		= 182,
	SDLK_WORLD_23		= 183,
	SDLK_WORLD_24		= 184,
	SDLK_WORLD_25		= 185,
	SDLK_WORLD_26		= 186,
	SDLK_WORLD_27		= 187,
	SDLK_WORLD_28		= 188,
	SDLK_WORLD_29		= 189,
	SDLK_WORLD_30		= 190,
	SDLK_WORLD_31		= 191,
	SDLK_WORLD_32		= 192,
	SDLK_WORLD_33		= 193,
	SDLK_WORLD_34		= 194,
	SDLK_WORLD_35		= 195,
	SDLK_WORLD_36		= 196,
	SDLK_WORLD_37		= 197,
	SDLK_WORLD_38		= 198,
	SDLK_WORLD_39		= 199,
	SDLK_WORLD_40		= 200,
	SDLK_WORLD_41		= 201,
	SDLK_WORLD_42		= 202,
	SDLK_WORLD_43		= 203,
	SDLK_WORLD_44		= 204,
	SDLK_WORLD_45		= 205,
	SDLK_WORLD_46		= 206,
	SDLK_WORLD_47		= 207,
	SDLK_WORLD_48		= 208,
	SDLK_WORLD_49		= 209,
	SDLK_WORLD_50		= 210,
	SDLK_WORLD_51		= 211,
	SDLK_WORLD_52		= 212,
	SDLK_WORLD_53		= 213,
	SDLK_WORLD_54		= 214,
	SDLK_WORLD_55		= 215,
	SDLK_WORLD_56		= 216,
	SDLK_WORLD_57		= 217,
	SDLK_WORLD_58		= 218,
	SDLK_WORLD_59		= 219,
	SDLK_WORLD_60		= 220,
	SDLK_WORLD_61		= 221,
	SDLK_WORLD_62		= 222,
	SDLK_WORLD_63		= 223,
	SDLK_WORLD_64		= 224,
	SDLK_WORLD_65		= 225,
	SDLK_WORLD_66		= 226,
	SDLK_WORLD_67		= 227,
	SDLK_WORLD_68		= 228,
	SDLK_WORLD_69		= 229,
	SDLK_WORLD_70		= 230,
	SDLK_WORLD_71		= 231,
	SDLK_WORLD_72		= 232,
	SDLK_WORLD_73		= 233,
	SDLK_WORLD_74		= 234,
	SDLK_WORLD_75		= 235,
	SDLK_WORLD_76		= 236,
	SDLK_WORLD_77		= 237,
	SDLK_WORLD_78		= 238,
	SDLK_WORLD_79		= 239,
	SDLK_WORLD_80		= 240,
	SDLK_WORLD_81		= 241,
	SDLK_WORLD_82		= 242,
	SDLK_WORLD_83		= 243,
	SDLK_WORLD_84		= 244,
	SDLK_WORLD_85		= 245,
	SDLK_WORLD_86		= 246,
	SDLK_WORLD_87		= 247,
	SDLK_WORLD_88		= 248,
	SDLK_WORLD_89		= 249,
	SDLK_WORLD_90		= 250,
	SDLK_WORLD_91		= 251,
	SDLK_WORLD_92		= 252,
	SDLK_WORLD_93		= 253,
	SDLK_WORLD_94		= 254,
	SDLK_WORLD_95		= 255,		/* 0xFF */

	/* Numeric keypad */
	SDLK_KP0		= 256,
	SDLK_KP1		= 257,
	SDLK_KP2		= 258,
	SDLK_KP3		= 259,
	SDLK_KP4		= 260,
	SDLK_KP5		= 261,
	SDLK_KP6		= 262,
	SDLK_KP7		= 263,
	SDLK_KP8		= 264,
	SDLK_KP9		= 265,
	SDLK_KP_PERIOD		= 266,
	SDLK_KP_DIVIDE		= 267,
	SDLK_KP_MULTIPLY	= 268,
	SDLK_KP_MINUS		= 269,
	SDLK_KP_PLUS		= 270,
	SDLK_KP_ENTER		= 271,
	SDLK_KP_EQUALS		= 272,

	/* Arrows + Home/End pad */
	SDLK_UP			= 273,
	SDLK_DOWN		= 274,
	SDLK_RIGHT		= 275,
	SDLK_LEFT		= 276,
	SDLK_INSERT		= 277,
	SDLK_HOME		= 278,
	SDLK_END		= 279,
	SDLK_PAGEUP		= 280,
	SDLK_PAGEDOWN		= 281,

	/* Function keys */
	SDLK_F1			= 282,
	SDLK_F2			= 283,
	SDLK_F3			= 284,
	SDLK_F4			= 285,
	SDLK_F5			= 286,
	SDLK_F6			= 287,
	SDLK_F7			= 288,
	SDLK_F8			= 289,
	SDLK_F9			= 290,
	SDLK_F10		= 291,
	SDLK_F11		= 292,
	SDLK_F12		= 293,
	SDLK_F13		= 294,
	SDLK_F14		= 295,
	SDLK_F15		= 296,

	/* Key state modifier keys */
	SDLK_NUMLOCK		= 300,
	SDLK_CAPSLOCK		= 301,
	SDLK_SCROLLOCK		= 302,
	SDLK_RSHIFT		= 303,
	SDLK_LSHIFT		= 304,
	SDLK_RCTRL		= 305,
	SDLK_LCTRL		= 306,
	SDLK_RALT		= 307,
	SDLK_LALT		= 308,
	SDLK_RMETA		= 309,
	SDLK_LMETA		= 310,
	SDLK_LSUPER		= 311,		/* Left "Windows" key */
	SDLK_RSUPER		= 312,		/* Right "Windows" key */
	SDLK_MODE		= 313,		/* "Alt Gr" key */
	SDLK_COMPOSE		= 314,		/* Multi-key compose key */

	/* Miscellaneous function keys */
	SDLK_HELP		= 315,
	SDLK_PRINT		= 316,
	SDLK_SYSREQ		= 317,
	SDLK_BREAK		= 318,
	SDLK_MENU		= 319,
	SDLK_POWER		= 320,		/* Power Macintosh power key */
	SDLK_EURO		= 321,		/* Some european keyboards */

	/* Add any other keys here */

	SDLK_LAST
} SDLKey;

/* Enumeration of valid key mods (possibly OR'd together) */
typedef enum {
	KMOD_NONE  = 0x0000,
	KMOD_LSHIFT= 0x0001,
	KMOD_RSHIFT= 0x0002,
	KMOD_LCTRL = 0x0040,
	KMOD_RCTRL = 0x0080,
	KMOD_LALT  = 0x0100,
	KMOD_RALT  = 0x0200,
	KMOD_LMETA = 0x0400,
	KMOD_RMETA = 0x0800,
	KMOD_NUM   = 0x1000,
	KMOD_CAPS  = 0x2000,
	KMOD_MODE  = 0x4000,
	KMOD_RESERVED = 0x8000
} SDLMod;

#define KMOD_CTRL	(KMOD_LCTRL|KMOD_RCTRL)
#define KMOD_SHIFT	(KMOD_LSHIFT|KMOD_RSHIFT)
#define KMOD_ALT	(KMOD_LALT|KMOD_RALT)
#define KMOD_META	(KMOD_LMETA|KMOD_RMETA)







/* Keysym structure
   - The scancode is hardware dependent, and should not be used by general
     applications.  If no hardware scancode is available, it will be 0.

   - The 'unicode' translated character is only available when character
     translation is enabled by the SDL_EnableUNICODE() API.  If non-zero,
     this is a UNICODE character corresponding to the keypress.  If the
     high 9 bits of the character are 0, then this maps to the equivalent
     ASCII character:
	char ch;
	if ( (keysym.unicode & 0xFF80) == 0 ) {
		ch = keysym.unicode & 0x7F;
	} else {
		An international character..
	}
 */
typedef struct {
	Uint8 scancode;			/* hardware specific scancode */
	SDLKey sym;			/* SDL virtual keysym */
	SDLMod mod;			/* current key modifiers */
	Uint16 unicode;			/* translated character */
} SDL_keysym;

/* This is the mask which refers to all hotkey bindings */
#define SDL_ALL_HOTKEYS		0xFFFFFFFF

/* Function prototypes */
/*
 * Enable/Disable UNICODE translation of keyboard input.
 * This translation has some overhead, so translation defaults off.
 * If 'enable' is 1, translation is enabled.
 * If 'enable' is 0, translation is disabled.
 * If 'enable' is -1, the translation state is not changed.
 * It returns the previous state of keyboard translation.
 */
extern int SDL_EnableUNICODE(int enable);

/*
 * Enable/Disable keyboard repeat.  Keyboard repeat defaults to off.
 * 'delay' is the initial delay in ms between the time when a key is
 * pressed, and keyboard repeat begins.
 * 'interval' is the time in ms between keyboard repeat events.
 */
#define SDL_DEFAULT_REPEAT_DELAY	500
#define SDL_DEFAULT_REPEAT_INTERVAL	30
/*
 * If 'delay' is set to 0, keyboard repeat is disabled.
 */
extern int SDL_EnableKeyRepeat(int delay, int interval);

/*
 * Get a snapshot of the current state of the keyboard.
 * Returns an array of keystates, indexed by the SDLK_* syms.
 * Used:
 * 	Uint8 *keystate = SDL_GetKeyState(NULL);
 *	if ( keystate[SDLK_RETURN] ) ... <RETURN> is pressed.
 */
#ifdef NOT_FOR_LUASWIG
extern Uint8 * SDL_GetKeyState(int *numkeys);
#endif // NOT_FOR_LUASWIG


/*
 * Get the current key modifier state
 */
extern SDLMod SDL_GetModState(void);

/*
 * Set the current key modifier state
 * This does not change the keyboard state, only the key modifier flags.
 */
extern void SDL_SetModState(SDLMod modstate);

/*
 * Get the name of an SDL virtual keysym
 */
extern char * SDL_GetKeyName(SDLKey key);











typedef struct WMcursor {
} WMcursor;	/* Implementation dependent */
typedef struct {
#ifdef NOT_FOR_LUASWIG
	SDL_Rect area;			/* The area of the mouse cursor */
	Sint16 hot_x, hot_y;		/* The "tip" of the cursor */
	Uint8 *data;			/* B/W cursor data */
	Uint8 *mask;			/* B/W cursor mask */
	Uint8 *save[2];			/* Place to save cursor area */
	WMcursor *wm_cursor;		/* Window-manager cursor */
#endif // NOT_FOR_LUASWIG
} SDL_Cursor;


#ifdef NOT_FOR_LUASWIG
/* Function prototypes */
/*
 * Retrieve the current state of the mouse.
 * The current button state is returned as a button bitmask, which can
 * be tested using the SDL_BUTTON(X) macros, and x and y are set to the
 * current mouse cursor position.  You can pass NULL for either x or y.
 */
extern Uint8 SDL_GetMouseState(int *x, int *y);

/*
 * Retrieve the current state of the mouse.
 * The current button state is returned as a button bitmask, which can
 * be tested using the SDL_BUTTON(X) macros, and x and y are set to the
 * mouse deltas since the last call to SDL_GetRelativeMouseState().
 */
extern Uint8 SDL_GetRelativeMouseState(int *x, int *y);
#endif // NOT_FOR_LUASWIG


// Wrap SDL_GetMouseState() and SDL_GetRelativeMouseState in a way we
// can use them from the scripting language.
%inline %{
	typedef struct {
		Uint8	buttons;
		int	x;
		int	y;
	} luaSDL_MouseState;

	luaSDL_MouseState*	luaSDL_GetMouseState()
	{
		static luaSDL_MouseState	s;
		s.buttons = SDL_GetMouseState(&s.x, &s.y);
		return &s;
	}	
	luaSDL_MouseState*	luaSDL_GetRelativeMouseState()
	{
		static luaSDL_MouseState	s;
		s.buttons = SDL_GetRelativeMouseState(&s.x, &s.y);
		return &s;
	}	
%}


/*
 * Set the position of the mouse cursor (generates a mouse motion event)
 */
extern void SDL_WarpMouse(Uint16 x, Uint16 y);

/*
 * Create a cursor using the specified data and mask (in MSB format).
 * The cursor width must be a multiple of 8 bits.
 *
 * The cursor is created in black and white according to the following:
 * data  mask    resulting pixel on screen
 *  0     1       White
 *  1     1       Black
 *  0     0       Transparent
 *  1     0       Inverted color if possible, black if not.
 *
 * Cursors created with this function must be freed with SDL_FreeCursor().
 */
extern SDL_Cursor *SDL_CreateCursor
		(Uint8 *data, Uint8 *mask, int w, int h, int hot_x, int hot_y);

/*
 * Set the currently active cursor to the specified one.
 * If the cursor is currently visible, the change will be immediately 
 * represented on the display.
 */
extern void SDL_SetCursor(SDL_Cursor *cursor);

/*
 * Returns the currently active cursor.
 */
extern SDL_Cursor * SDL_GetCursor(void);

/*
 * Deallocates a cursor created with SDL_CreateCursor().
 */
extern void SDL_FreeCursor(SDL_Cursor *cursor);

/*
 * Toggle whether or not the cursor is shown on the screen.
 * The cursor start off displayed, but can be turned off.
 * SDL_ShowCursor() returns 1 if the cursor was being displayed
 * before the call, or 0 if it was not.  You can query the current
 * state by passing a 'toggle' value of -1.
 */
extern int SDL_ShowCursor(int toggle);

/* Used as a mask when testing buttons in buttonstate
   Button 1:	Left mouse button
   Button 2:	Middle mouse button
   Button 3:	Right mouse button
 */
#define SDL_BUTTON(X)		(SDL_PRESSED<<(X-1))
#define SDL_BUTTON_LEFT		1
#define SDL_BUTTON_MIDDLE	2
#define SDL_BUTTON_RIGHT	3
#define SDL_BUTTON_LMASK	SDL_BUTTON(SDL_BUTTON_LEFT)
#define SDL_BUTTON_MMASK	SDL_BUTTON(SDL_BUTTON_MIDDLE)
#define SDL_BUTTON_RMASK	SDL_BUTTON(SDL_BUTTON_RIGHT)



/* Event enumerations */
enum { SDL_NOEVENT = 0,			/* Unused (do not remove) */
       SDL_ACTIVEEVENT,			/* Application loses/gains visibility */
       SDL_KEYDOWN,			/* Keys pressed */
       SDL_KEYUP,			/* Keys released */
       SDL_MOUSEMOTION,			/* Mouse moved */
       SDL_MOUSEBUTTONDOWN,		/* Mouse button pressed */
       SDL_MOUSEBUTTONUP,		/* Mouse button released */
       SDL_JOYAXISMOTION,		/* Joystick axis motion */
       SDL_JOYBALLMOTION,		/* Joystick trackball motion */
       SDL_JOYHATMOTION,		/* Joystick hat position change */
       SDL_JOYBUTTONDOWN,		/* Joystick button pressed */
       SDL_JOYBUTTONUP,			/* Joystick button released */
       SDL_QUIT,			/* User-requested quit */
       SDL_SYSWMEVENT,			/* System specific event */
       SDL_EVENT_RESERVEDA,		/* Reserved for future use.. */
       SDL_EVENT_RESERVEDB,		/* Reserved for future use.. */
       SDL_VIDEORESIZE,			/* User resized video mode */
       SDL_VIDEOEXPOSE,			/* Screen needs to be redrawn */
       SDL_EVENT_RESERVED2,		/* Reserved for future use.. */
       SDL_EVENT_RESERVED3,		/* Reserved for future use.. */
       SDL_EVENT_RESERVED4,		/* Reserved for future use.. */
       SDL_EVENT_RESERVED5,		/* Reserved for future use.. */
       SDL_EVENT_RESERVED6,		/* Reserved for future use.. */
       SDL_EVENT_RESERVED7,		/* Reserved for future use.. */
       /* Events SDL_USEREVENT through SDL_MAXEVENTS-1 are for your use */
       SDL_USEREVENT = 24,
       /* This last event is only for bounding internal arrays
	  It is the number of bits in the event mask datatype -- Uint32
        */
       SDL_NUMEVENTS = 32
};

/* Predefined event masks */
#define SDL_EVENTMASK(X)	(1<<(X))
enum {
	SDL_ACTIVEEVENTMASK	= (1<<(SDL_ACTIVEEVENT)),
	SDL_KEYDOWNMASK		= (1<<(SDL_KEYDOWN)),
	SDL_KEYUPMASK		= (1<<(SDL_KEYUP)),
	SDL_MOUSEMOTIONMASK	= (1<<(SDL_MOUSEMOTION)),
	SDL_MOUSEBUTTONDOWNMASK	= (1<<(SDL_MOUSEBUTTONDOWN)),
	SDL_MOUSEBUTTONUPMASK	= (1<<(SDL_MOUSEBUTTONUP)),
	SDL_MOUSEEVENTMASK	= (1<<(SDL_MOUSEMOTION))|
	                          (1<<(SDL_MOUSEBUTTONDOWN))|
	                          (1<<(SDL_MOUSEBUTTONUP)),
	SDL_JOYAXISMOTIONMASK	= (1<<(SDL_JOYAXISMOTION)),
	SDL_JOYBALLMOTIONMASK	= (1<<(SDL_JOYBALLMOTION)),
	SDL_JOYHATMOTIONMASK	= (1<<(SDL_JOYHATMOTION)),
	SDL_JOYBUTTONDOWNMASK	= (1<<(SDL_JOYBUTTONDOWN)),
	SDL_JOYBUTTONUPMASK	= (1<<(SDL_JOYBUTTONUP)),
	SDL_JOYEVENTMASK	= (1<<(SDL_JOYAXISMOTION))|
	                          (1<<(SDL_JOYBALLMOTION))|
	                          (1<<(SDL_JOYHATMOTION))|
	                          (1<<(SDL_JOYBUTTONDOWN))|
	                          (1<<(SDL_JOYBUTTONUP)),
	SDL_VIDEORESIZEMASK	= (1<<(SDL_VIDEORESIZE)),
	SDL_VIDEOEXPOSEMASK	= (1<<(SDL_VIDEOEXPOSE)),
	SDL_QUITMASK		= (1<<(SDL_QUIT)),
	SDL_SYSWMEVENTMASK	= (1<<(SDL_SYSWMEVENT))
};
#define SDL_ALLEVENTS		0xFFFFFFFF

/* Application visibility event structure */
typedef struct {
	Uint8 type;	/* SDL_ACTIVEEVENT */
	Uint8 gain;	/* Whether given states were gained or lost (1/0) */
	Uint8 state;	/* A mask of the focus states */
} SDL_ActiveEvent;

/* Keyboard event structure */
typedef struct {
	Uint8 type;	/* SDL_KEYDOWN or SDL_KEYUP */
	Uint8 which;	/* The keyboard device index */
	Uint8 state;	/* SDL_PRESSED or SDL_RELEASED */
	SDL_keysym keysym;
} SDL_KeyboardEvent;

/* Mouse motion event structure */
typedef struct {
	Uint8 type;	/* SDL_MOUSEMOTION */
	Uint8 which;	/* The mouse device index */
	Uint8 state;	/* The current button state */
	Uint16 x, y;	/* The X/Y coordinates of the mouse */
	Sint16 xrel;	/* The relative motion in the X direction */
	Sint16 yrel;	/* The relative motion in the Y direction */
} SDL_MouseMotionEvent;

/* Mouse button event structure */
typedef struct {
	Uint8 type;	/* SDL_MOUSEBUTTONDOWN or SDL_MOUSEBUTTONUP */
	Uint8 which;	/* The mouse device index */
	Uint8 button;	/* The mouse button index */
	Uint8 state;	/* SDL_PRESSED or SDL_RELEASED */
	Uint16 x, y;	/* The X/Y coordinates of the mouse at press time */
} SDL_MouseButtonEvent;

/* Joystick axis motion event structure */
typedef struct {
	Uint8 type;	/* SDL_JOYAXISMOTION */
	Uint8 which;	/* The joystick device index */
	Uint8 axis;	/* The joystick axis index */
	Sint16 value;	/* The axis value (range: -32768 to 32767) */
} SDL_JoyAxisEvent;

/* Joystick trackball motion event structure */
typedef struct {
	Uint8 type;	/* SDL_JOYBALLMOTION */
	Uint8 which;	/* The joystick device index */
	Uint8 ball;	/* The joystick trackball index */
	Sint16 xrel;	/* The relative motion in the X direction */
	Sint16 yrel;	/* The relative motion in the Y direction */
} SDL_JoyBallEvent;

/* Joystick hat position change event structure */
typedef struct {
	Uint8 type;	/* SDL_JOYHATMOTION */
	Uint8 which;	/* The joystick device index */
	Uint8 hat;	/* The joystick hat index */
	Uint8 value;	/* The hat position value:
				8   1   2
				7   0   3
				6   5   4
			   Note that zero means the POV is centered.
			*/
} SDL_JoyHatEvent;

/* Joystick button event structure */
typedef struct {
	Uint8 type;	/* SDL_JOYBUTTONDOWN or SDL_JOYBUTTONUP */
	Uint8 which;	/* The joystick device index */
	Uint8 button;	/* The joystick button index */
	Uint8 state;	/* SDL_PRESSED or SDL_RELEASED */
} SDL_JoyButtonEvent;

/* The "window resized" event
   When you get this event, you are responsible for setting a new video
   mode with the new width and height.
 */
typedef struct {
	Uint8 type;	/* SDL_VIDEORESIZE */
	int w;		/* New width */
	int h;		/* New height */
} SDL_ResizeEvent;

/* The "screen redraw" event */
typedef struct {
	Uint8 type;	/* SDL_VIDEOEXPOSE */
} SDL_ExposeEvent;

/* The "quit requested" event */
typedef struct {
	Uint8 type;	/* SDL_QUIT */
} SDL_QuitEvent;

/* A user-defined event type */
typedef struct {
	Uint8 type;	/* SDL_USEREVENT through SDL_NUMEVENTS-1 */
	int code;	/* User defined event code */
	void *data1;	/* User defined data pointer */
	void *data2;	/* User defined data pointer */
} SDL_UserEvent;

#ifdef NOT_FOR_LUASWIG
/* If you want to use this event, you should include SDL_syswm.h */
struct SDL_SysWMmsg;
typedef struct SDL_SysWMmsg SDL_SysWMmsg;
#endif // NOT_FOR_LUASWIG
typedef struct {
#ifdef NOT_FOR_LUASWIG
	Uint8 type;
	SDL_SysWMmsg *msg;
#endif // NOT_FOR_LUASWIG
} SDL_SysWMEvent;

/* General event structure */
typedef union {
	Uint8 type;
	SDL_ActiveEvent active;
	SDL_KeyboardEvent key;
	SDL_MouseMotionEvent motion;
	SDL_MouseButtonEvent button;
	SDL_JoyAxisEvent jaxis;
	SDL_JoyBallEvent jball;
	SDL_JoyHatEvent jhat;
	SDL_JoyButtonEvent jbutton;
	SDL_ResizeEvent resize;
	SDL_ExposeEvent expose;
	SDL_QuitEvent quit;
	SDL_UserEvent user;
	SDL_SysWMEvent syswm;

	SDL_Event();
	~SDL_Event();
} SDL_Event;


/* Function prototypes */

/* Pumps the event loop, gathering events from the input devices.
   This function updates the event queue and internal input device state.
   This should only be run in the thread that sets the video mode.
*/
extern void SDL_PumpEvents(void);

/* Checks the event queue for messages and optionally returns them.
   If 'action' is SDL_ADDEVENT, up to 'numevents' events will be added to
   the back of the event queue.
   If 'action' is SDL_PEEKEVENT, up to 'numevents' events at the front
   of the event queue, matching 'mask', will be returned and will not
   be removed from the queue.
   If 'action' is SDL_GETEVENT, up to 'numevents' events at the front 
   of the event queue, matching 'mask', will be returned and will be
   removed from the queue.
   This function returns the number of events actually stored, or -1
   if there was an error.  This function is thread-safe.
*/
typedef enum {
	SDL_ADDEVENT,
	SDL_PEEKEVENT,
	SDL_GETEVENT
} SDL_eventaction;
/* */
extern int SDL_PeepEvents(SDL_Event *events, int numevents,
				SDL_eventaction action, Uint32 mask);

/* Polls for currently pending events, and returns 1 if there are any pending
   events, or 0 if there are none available.  If 'event' is not NULL, the next
   event is removed from the queue and stored in that area.
 */
extern int SDL_PollEvent(SDL_Event *event);

/* Waits indefinitely for the next available event, returning 1, or 0 if there
   was an error while waiting for events.  If 'event' is not NULL, the next
   event is removed from the queue and stored in that area.
 */
extern int SDL_WaitEvent(SDL_Event *event);

/* Add an event to the event queue.
   This function returns 0, or -1 if the event couldn't be added to
   the event queue.  If the event queue is full, this function fails.
 */
extern int SDL_PushEvent(SDL_Event *event);


#ifdef NOT_FOR_LUASWIG
/*
  This function sets up a filter to process all events before they
  change internal state and are posted to the internal event queue.

  The filter is protypted as:
*/
typedef int (*SDL_EventFilter)(const SDL_Event *event);
/*
  If the filter returns 1, then the event will be added to the internal queue.
  If it returns 0, then the event will be dropped from the queue, but the 
  internal state will still be updated.  This allows selective filtering of
  dynamically arriving events.

  WARNING:  Be very careful of what you do in the event filter function, as 
            it may run in a different thread!

  There is one caveat when dealing with the SDL_QUITEVENT event type.  The
  event filter is only called when the window manager desires to close the
  application window.  If the event filter returns 1, then the window will
  be closed, otherwise the window will remain open if possible.
  If the quit event is generated by an interrupt signal, it will bypass the
  internal queue and be delivered to the application at the next event poll.
*/
extern void SDL_SetEventFilter(SDL_EventFilter filter);

/*
  Return the current event filter - can be used to "chain" filters.
  If there is no event filter set, this function returns NULL.
*/
extern SDL_EventFilter SDL_GetEventFilter(void);

#endif // NOT_FOR_LUASWIG


/*
  This function allows you to set the state of processing certain events.
  If 'state' is set to SDL_IGNORE, that event will be automatically dropped
  from the event queue and will not event be filtered.
  If 'state' is set to SDL_ENABLE, that event will be processed normally.
  If 'state' is set to SDL_QUERY, SDL_EventState() will return the 
  current processing state of the specified event.
*/
#define SDL_QUERY	-1
#define SDL_IGNORE	 0
#define SDL_DISABLE	 0
#define SDL_ENABLE	 1
extern Uint8 SDL_EventState(Uint8 type, int state);


/* Transparency definitions: These define alpha as the opacity of a surface */
#define SDL_ALPHA_OPAQUE 255
#define SDL_ALPHA_TRANSPARENT 0

/* Useful data types */
typedef struct {
	Sint16 x, y;
	Uint16 w, h;

	SDL_Rect();
	~SDL_Rect();
} SDL_Rect;

typedef struct {
	Uint8 r;
	Uint8 g;
	Uint8 b;
	Uint8 unused;
} SDL_Color;

typedef struct {
	int       ncolors;
	SDL_Color *colors;
} SDL_Palette;

/* Everything in the pixel format structure is read-only */
typedef struct SDL_PixelFormat {
	SDL_Palette *palette;
	Uint8  BitsPerPixel;
	Uint8  BytesPerPixel;
	Uint8  Rloss;
	Uint8  Gloss;
	Uint8  Bloss;
	Uint8  Aloss;
	Uint8  Rshift;
	Uint8  Gshift;
	Uint8  Bshift;
	Uint8  Ashift;
	Uint32 Rmask;
	Uint32 Gmask;
	Uint32 Bmask;
	Uint32 Amask;

	/* RGB color key information */
	Uint32 colorkey;
	/* Alpha value information (per-surface alpha) */
	Uint8  alpha;
} SDL_PixelFormat;

/* typedef for private surface blitting functions */
struct SDL_Surface;
typedef int (*SDL_blit)(struct SDL_Surface *src, SDL_Rect *srcrect,
			struct SDL_Surface *dst, SDL_Rect *dstrect);

/* This structure should be treated as read-only, except for 'pixels',
   which, if not NULL, contains the raw pixel data for the surface.
*/
typedef struct SDL_Surface {
	Uint32 flags;				/* Read-only */
	SDL_PixelFormat *format;		/* Read-only */
	int w, h;				/* Read-only */
	Uint16 pitch;				/* Read-only */
	void *pixels;				/* Read-write */
#ifdef NOT_FOR_LUASWIG
	int offset;				/* Private */

	/* Hardware-specific surface info */
	struct private_hwdata *hwdata;

	/* clipping information */
	SDL_Rect clip_rect;			/* Read-only */
	Uint32 unused1;				/* for binary compatibility */

	/* Allow recursive locks */
	Uint32 locked;				/* Private */

	/* info for fast blit mapping to other surfaces */
	struct SDL_BlitMap *map;		/* Private */

	/* format version, bumped at every change to invalidate blit maps */
	unsigned int format_version;		/* Private */

	/* Reference count -- used when freeing surface */
	int refcount;				/* Read-mostly */
#endif // NOT_FOR_LUASWIG
} SDL_Surface;

/* These are the currently supported flags for the SDL_surface */
/* Available for SDL_CreateRGBSurface() or SDL_SetVideoMode() */
#define SDL_SWSURFACE	0x00000000	/* Surface is in system memory */
#define SDL_HWSURFACE	0x00000001	/* Surface is in video memory */
#define SDL_ASYNCBLIT	0x00000004	/* Use asynchronous blits if possible */
/* Available for SDL_SetVideoMode() */
#define SDL_ANYFORMAT	0x10000000	/* Allow any video depth/pixel-format */
#define SDL_HWPALETTE	0x20000000	/* Surface has exclusive palette */
#define SDL_DOUBLEBUF	0x40000000	/* Set up double-buffered video mode */
#define SDL_FULLSCREEN	0x80000000	/* Surface is a full screen display */
#define SDL_OPENGL      0x00000002      /* Create an OpenGL rendering context */
#define SDL_OPENGLBLIT	0x0000000A	/* Create an OpenGL rendering context and use it for blitting */
#define SDL_RESIZABLE	0x00000010	/* This video mode may be resized */
#define SDL_NOFRAME	0x00000020	/* No window caption or edge frame */
/* Used internally (read-only) */
#define SDL_HWACCEL	0x00000100	/* Blit uses hardware acceleration */
#define SDL_SRCCOLORKEY	0x00001000	/* Blit uses a source color key */
#define SDL_RLEACCELOK	0x00002000	/* Private flag */
#define SDL_RLEACCEL	0x00004000	/* Surface is RLE encoded */
#define SDL_SRCALPHA	0x00010000	/* Blit uses source alpha blending */
#define SDL_PREALLOC	0x01000000	/* Surface uses preallocated memory */

/* Evaluates to true if the surface needs to be locked before access */
#define SDL_MUSTLOCK(surface)	\
  (surface->offset ||		\
  ((surface->flags & (SDL_HWSURFACE|SDL_ASYNCBLIT|SDL_RLEACCEL)) != 0))


/* Useful for determining the video hardware capabilities */
// tulrich: luaswig doesn't like the bitfields -- will need to wrap manually ...
typedef struct {
#ifdef NOT_FOR_LUASWIG
//	Uint32 hw_available :1;	/* Flag: Can you create hardware surfaces? */
//	Uint32 wm_available :1;	/* Flag: Can you talk to a window manager? */
//	Uint32 UnusedBits1  :6;
//	Uint32 UnusedBits2  :1;
//	Uint32 blit_hw      :1;	/* Flag: Accelerated blits HW --> HW */
//	Uint32 blit_hw_CC   :1;	/* Flag: Accelerated blits with Colorkey */
//	Uint32 blit_hw_A    :1;	/* Flag: Accelerated blits with Alpha */
//	Uint32 blit_sw      :1;	/* Flag: Accelerated blits SW --> HW */
//	Uint32 blit_sw_CC   :1;	/* Flag: Accelerated blits with Colorkey */
//	Uint32 blit_sw_A    :1;	/* Flag: Accelerated blits with Alpha */
//	Uint32 blit_fill    :1;	/* Flag: Accelerated color fill */
//	Uint32 UnusedBits3  :16;
#else // for luaswig
	Uint32	hw_available;
#endif // for luaswig
	Uint32 video_mem;	/* The total amount of video memory (in K) */
	SDL_PixelFormat *vfmt;	/* Value: The format of the video surface */
} SDL_VideoInfo;



/* The most common video overlay formats.
   For an explanation of these pixel formats, see:
	http://www.webartz.com/fourcc/indexyuv.htm

   For information on the relationship between color spaces, see:
   http://www.neuro.sfc.keio.ac.jp/~aly/polygon/info/color-space-faq.html
 */
#define SDL_YV12_OVERLAY  0x32315659	/* Planar mode: Y + V + U  (3 planes) */
#define SDL_IYUV_OVERLAY  0x56555949	/* Planar mode: Y + U + V  (3 planes) */
#define SDL_YUY2_OVERLAY  0x32595559	/* Packed mode: Y0+U0+Y1+V0 (1 plane) */
#define SDL_UYVY_OVERLAY  0x59565955	/* Packed mode: U0+Y0+V0+Y1 (1 plane) */
#define SDL_YVYU_OVERLAY  0x55595659	/* Packed mode: Y0+V0+Y1+U0 (1 plane) */

/* The YUV hardware video overlay */
// tulrich: luaswig doesn't like bitfields...
typedef struct SDL_Overlay {
#ifdef NOT_FOR_LUASWIG
	Uint32 format;				/* Read-only */
	int w, h;				/* Read-only */
	int planes;				/* Read-only */
	Uint16 *pitches;			/* Read-only */
	Uint8 **pixels;				/* Read-write */

	/* Hardware-specific surface info */
	struct private_yuvhwfuncs *hwfuncs;
	struct private_yuvhwdata *hwdata;

	/* Special flags */
	Uint32 hw_overlay :1;	/* Flag: This overlay hardware accelerated? */
	Uint32 UnusedBits :31;
	Uint32 hw_overlay;
#endif // NOT_FOR_LUASWIG
} SDL_Overlay;


/* Public enumeration for setting the OpenGL window attributes. */
typedef enum {
    SDL_GL_RED_SIZE,
    SDL_GL_GREEN_SIZE,
    SDL_GL_BLUE_SIZE,
    SDL_GL_ALPHA_SIZE,
    SDL_GL_BUFFER_SIZE,
    SDL_GL_DOUBLEBUFFER,
    SDL_GL_DEPTH_SIZE,
    SDL_GL_STENCIL_SIZE,
    SDL_GL_ACCUM_RED_SIZE,
    SDL_GL_ACCUM_GREEN_SIZE,
    SDL_GL_ACCUM_BLUE_SIZE,
    SDL_GL_ACCUM_ALPHA_SIZE
} SDL_GLattr;

/* flags for SDL_SetPalette() */
#define SDL_LOGPAL 0x01
#define SDL_PHYSPAL 0x02

/* Function prototypes */

/* These functions are used internally, and should not be used unless you
 * have a specific need to specify the video driver you want to use.
 * You should normally use SDL_Init() or SDL_InitSubSystem().
 *
 * SDL_VideoInit() initializes the video subsystem -- sets up a connection
 * to the window manager, etc, and determines the current video mode and
 * pixel format, but does not initialize a window or graphics mode.
 * Note that event handling is activated by this routine.
 *
 * If you use both sound and video in your application, you need to call
 * SDL_Init() before opening the sound device, otherwise under Win32 DirectX,
 * you won't be able to set full-screen display modes.
 */
extern int SDL_VideoInit(const char *driver_name, Uint32 flags);
extern void SDL_VideoQuit(void);

/* This function fills the given character buffer with the name of the
 * video driver, and returns a pointer to it if the video driver has
 * been initialized.  It returns NULL if no driver has been initialized.
 */
extern char *SDL_VideoDriverName(char *namebuf, int maxlen);

/*
 * This function returns a pointer to the current display surface.
 * If SDL is doing format conversion on the display surface, this
 * function returns the publicly visible surface, not the real video
 * surface.
 */
extern SDL_Surface * SDL_GetVideoSurface(void);

/*
 * This function returns a read-only pointer to information about the
 * video hardware.  If this is called before SDL_SetVideoMode(), the 'vfmt'
 * member of the returned structure will contain the pixel format of the
 * "best" video mode.
 */
extern const SDL_VideoInfo * SDL_GetVideoInfo(void);

/* 
 * Check to see if a particular video mode is supported.
 * It returns 0 if the requested mode is not supported under any bit depth,
 * or returns the bits-per-pixel of the closest available mode with the
 * given width and height.  If this bits-per-pixel is different from the
 * one used when setting the video mode, SDL_SetVideoMode() will succeed,
 * but will emulate the requested bits-per-pixel with a shadow surface.
 *
 * The arguments to SDL_VideoModeOK() are the same ones you would pass to
 * SDL_SetVideoMode()
 */
extern int SDL_VideoModeOK(int width, int height, int bpp, Uint32 flags);

/*
 * Return a pointer to an array of available screen dimensions for the
 * given format and video flags, sorted largest to smallest.  Returns 
 * NULL if there are no dimensions available for a particular format, 
 * or (SDL_Rect **)-1 if any dimension is okay for the given format.
 *
 * If 'format' is NULL, the mode list will be for the format given 
 * by SDL_GetVideoInfo()->vfmt
 */
extern SDL_Rect ** SDL_ListModes(SDL_PixelFormat *format, Uint32 flags);

/*
 * Set up a video mode with the specified width, height and bits-per-pixel.
 *
 * If 'bpp' is 0, it is treated as the current display bits per pixel.
 *
 * If SDL_ANYFORMAT is set in 'flags', the SDL library will try to set the
 * requested bits-per-pixel, but will return whatever video pixel format is
 * available.  The default is to emulate the requested pixel format if it
 * is not natively available.
 *
 * If SDL_HWSURFACE is set in 'flags', the video surface will be placed in
 * video memory, if possible, and you may have to call SDL_LockSurface()
 * in order to access the raw framebuffer.  Otherwise, the video surface
 * will be created in system memory.
 *
 * If SDL_ASYNCBLIT is set in 'flags', SDL will try to perform rectangle
 * updates asynchronously, but you must always lock before accessing pixels.
 * SDL will wait for updates to complete before returning from the lock.
 *
 * If SDL_HWPALETTE is set in 'flags', the SDL library will guarantee
 * that the colors set by SDL_SetColors() will be the colors you get.
 * Otherwise, in 8-bit mode, SDL_SetColors() may not be able to set all
 * of the colors exactly the way they are requested, and you should look
 * at the video surface structure to determine the actual palette.
 * If SDL cannot guarantee that the colors you request can be set, 
 * i.e. if the colormap is shared, then the video surface may be created
 * under emulation in system memory, overriding the SDL_HWSURFACE flag.
 *
 * If SDL_FULLSCREEN is set in 'flags', the SDL library will try to set
 * a fullscreen video mode.  The default is to create a windowed mode
 * if the current graphics system has a window manager.
 * If the SDL library is able to set a fullscreen video mode, this flag 
 * will be set in the surface that is returned.
 *
 * If SDL_DOUBLEBUF is set in 'flags', the SDL library will try to set up
 * two surfaces in video memory and swap between them when you call 
 * SDL_Flip().  This is usually slower than the normal single-buffering
 * scheme, but prevents "tearing" artifacts caused by modifying video 
 * memory while the monitor is refreshing.  It should only be used by 
 * applications that redraw the entire screen on every update.
 *
 * If SDL_RESIZABLE is set in 'flags', the SDL library will allow the
 * window manager, if any, to resize the window at runtime.  When this
 * occurs, SDL will send a SDL_VIDEORESIZE event to you application,
 * and you must respond to the event by re-calling SDL_SetVideoMode()
 * with the requested size (or another size that suits the application).
 *
 * If SDL_NOFRAME is set in 'flags', the SDL library will create a window
 * without any title bar or frame decoration.  Fullscreen video modes have
 * this flag set automatically.
 *
 * This function returns the video framebuffer surface, or NULL if it fails.
 *
 * If you rely on functionality provided by certain video flags, check the
 * flags of the returned surface to make sure that functionality is available.
 * SDL will fall back to reduced functionality if the exact flags you wanted
 * are not available.
 */
extern SDL_Surface *SDL_SetVideoMode
			(int width, int height, int bpp, Uint32 flags);

/*
 * Makes sure the given list of rectangles is updated on the given screen.
 * If 'x', 'y', 'w' and 'h' are all 0, SDL_UpdateRect will update the entire
 * screen.
 * These functions should not be called while 'screen' is locked.
 */
extern void SDL_UpdateRects
		(SDL_Surface *screen, int numrects, SDL_Rect *rects);
extern void SDL_UpdateRect
		(SDL_Surface *screen, Sint32 x, Sint32 y, Uint32 w, Uint32 h);

/*
 * On hardware that supports double-buffering, this function sets up a flip
 * and returns.  The hardware will wait for vertical retrace, and then swap
 * video buffers before the next video surface blit or lock will return.
 * On hardware that doesn not support double-buffering, this is equivalent
 * to calling SDL_UpdateRect(screen, 0, 0, 0, 0);
 * The SDL_DOUBLEBUF flag must have been passed to SDL_SetVideoMode() when
 * setting the video mode for this function to perform hardware flipping.
 * This function returns 0 if successful, or -1 if there was an error.
 */
extern int SDL_Flip(SDL_Surface *screen);

/*
 * Set the gamma correction for each of the color channels.
 * The gamma values range (approximately) between 0.1 and 10.0
 * 
 * If this function isn't supported directly by the hardware, it will
 * be emulated using gamma ramps, if available.  If successful, this
 * function returns 0, otherwise it returns -1.
 */
extern int SDL_SetGamma(float red, float green, float blue);

/*
 * Set the gamma translation table for the red, green, and blue channels
 * of the video hardware.  Each table is an array of 256 16-bit quantities,
 * representing a mapping between the input and output for that channel.
 * The input is the index into the array, and the output is the 16-bit
 * gamma value at that index, scaled to the output color precision.
 * 
 * You may pass NULL for any of the channels to leave it unchanged.
 * If the call succeeds, it will return 0.  If the display driver or
 * hardware does not support gamma translation, or otherwise fails,
 * this function will return -1.
 */
extern int SDL_SetGammaRamp(Uint16 *red, Uint16 *green, Uint16 *blue);

/*
 * Retrieve the current values of the gamma translation tables.
 * 
 * You must pass in valid pointers to arrays of 256 16-bit quantities.
 * Any of the pointers may be NULL to ignore that channel.
 * If the call succeeds, it will return 0.  If the display driver or
 * hardware does not support gamma translation, or otherwise fails,
 * this function will return -1.
 */
extern int SDL_GetGammaRamp(Uint16 *red, Uint16 *green, Uint16 *blue);

/*
 * Sets a portion of the colormap for the given 8-bit surface.  If 'surface'
 * is not a palettized surface, this function does nothing, returning 0.
 * If all of the colors were set as passed to SDL_SetColors(), it will
 * return 1.  If not all the color entries were set exactly as given,
 * it will return 0, and you should look at the surface palette to
 * determine the actual color palette.
 *
 * When 'surface' is the surface associated with the current display, the
 * display colormap will be updated with the requested colors.  If 
 * SDL_HWPALETTE was set in SDL_SetVideoMode() flags, SDL_SetColors()
 * will always return 1, and the palette is guaranteed to be set the way
 * you desire, even if the window colormap has to be warped or run under
 * emulation.
 */
extern int SDL_SetColors(SDL_Surface *surface, 
			SDL_Color *colors, int firstcolor, int ncolors);

/*
 * Sets a portion of the colormap for a given 8-bit surface.
 * 'flags' is one or both of:
 * SDL_LOGPAL  -- set logical palette, which controls how blits are mapped
 *                to/from the surface,
 * SDL_PHYSPAL -- set physical palette, which controls how pixels look on
 *                the screen
 * Only screens have physical palettes. Separate change of physical/logical
 * palettes is only possible if the screen has SDL_HWPALETTE set.
 *
 * The return value is 1 if all colours could be set as requested, and 0
 * otherwise.
 *
 * SDL_SetColors() is equivalent to calling this function with
 *     flags = (SDL_LOGPAL|SDL_PHYSPAL).
 */
extern int SDL_SetPalette(SDL_Surface *surface, int flags,
				   SDL_Color *colors, int firstcolor,
				   int ncolors);

/*
 * Maps an RGB triple to an opaque pixel value for a given pixel format
 */
extern Uint32 SDL_MapRGB
			(SDL_PixelFormat *format, Uint8 r, Uint8 g, Uint8 b);

/*
 * Maps an RGBA quadruple to a pixel value for a given pixel format
 */
extern Uint32 SDL_MapRGBA(SDL_PixelFormat *format,
				   Uint8 r, Uint8 g, Uint8 b, Uint8 a);

/*
 * Maps a pixel value into the RGB components for a given pixel format
 */
extern void SDL_GetRGB(Uint32 pixel, SDL_PixelFormat *fmt,
				Uint8 *r, Uint8 *g, Uint8 *b);

/*
 * Maps a pixel value into the RGBA components for a given pixel format
 */
extern void SDL_GetRGBA(Uint32 pixel, SDL_PixelFormat *fmt,
				 Uint8 *r, Uint8 *g, Uint8 *b, Uint8 *a);

/*
 * Allocate and free an RGB surface (must be called after SDL_SetVideoMode)
 * If the depth is 4 or 8 bits, an empty palette is allocated for the surface.
 * If the depth is greater than 8 bits, the pixel format is set using the
 * flags '[RGB]mask'.
 * If the function runs out of memory, it will return NULL.
 *
 * The 'flags' tell what kind of surface to create.
 * SDL_SWSURFACE means that the surface should be created in system memory.
 * SDL_HWSURFACE means that the surface should be created in video memory,
 * with the same format as the display surface.  This is useful for surfaces
 * that will not change much, to take advantage of hardware acceleration
 * when being blitted to the display surface.
 * SDL_ASYNCBLIT means that SDL will try to perform asynchronous blits with
 * this surface, but you must always lock it before accessing the pixels.
 * SDL will wait for current blits to finish before returning from the lock.
 * SDL_SRCCOLORKEY indicates that the surface will be used for colorkey blits.
 * If the hardware supports acceleration of colorkey blits between
 * two surfaces in video memory, SDL will try to place the surface in
 * video memory. If this isn't possible or if there is no hardware
 * acceleration available, the surface will be placed in system memory.
 * SDL_SRCALPHA means that the surface will be used for alpha blits and 
 * if the hardware supports hardware acceleration of alpha blits between
 * two surfaces in video memory, to place the surface in video memory
 * if possible, otherwise it will be placed in system memory.
 * If the surface is created in video memory, blits will be _much_ faster,
 * but the surface format must be identical to the video surface format,
 * and the only way to access the pixels member of the surface is to use
 * the SDL_LockSurface() and SDL_UnlockSurface() calls.
 * If the requested surface actually resides in video memory, SDL_HWSURFACE
 * will be set in the flags member of the returned surface.  If for some
 * reason the surface could not be placed in video memory, it will not have
 * the SDL_HWSURFACE flag set, and will be created in system memory instead.
 */
#define SDL_AllocSurface    SDL_CreateRGBSurface
extern SDL_Surface *SDL_CreateRGBSurface
			(Uint32 flags, int width, int height, int depth, 
			Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask);
extern SDL_Surface *SDL_CreateRGBSurfaceFrom(void *pixels,
			int width, int height, int depth, int pitch,
			Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask);
extern void SDL_FreeSurface(SDL_Surface *surface);

/*
 * SDL_LockSurface() sets up a surface for directly accessing the pixels.
 * Between calls to SDL_LockSurface()/SDL_UnlockSurface(), you can write
 * to and read from 'surface->pixels', using the pixel format stored in 
 * 'surface->format'.  Once you are done accessing the surface, you should 
 * use SDL_UnlockSurface() to release it.
 *
 * Not all surfaces require locking.  If SDL_MUSTLOCK(surface) evaluates
 * to 0, then you can read and write to the surface at any time, and the
 * pixel format of the surface will not change.  In particular, if the
 * SDL_HWSURFACE flag is not given when calling SDL_SetVideoMode(), you
 * will not need to lock the display surface before accessing it.
 * 
 * No operating system or library calls should be made between lock/unlock
 * pairs, as critical system locks may be held during this time.
 *
 * SDL_LockSurface() returns 0, or -1 if the surface couldn't be locked.
 */
extern int SDL_LockSurface(SDL_Surface *surface);
extern void SDL_UnlockSurface(SDL_Surface *surface);

/*
 * Load a surface from a seekable SDL data source (memory or file.)
 * If 'freesrc' is non-zero, the source will be closed after being read.
 * Returns the new surface, or NULL if there was an error.
 * The new surface should be freed with SDL_FreeSurface().
 */
extern SDL_Surface * SDL_LoadBMP_RW(SDL_RWops *src, int freesrc);

/* Convenience macro -- load a surface from a file */
#define SDL_LoadBMP(file)	SDL_LoadBMP_RW(SDL_RWFromFile(file, "rb"), 1)

/*
 * Save a surface to a seekable SDL data source (memory or file.)
 * If 'freedst' is non-zero, the source will be closed after being written.
 * Returns 0 if successful or -1 if there was an error.
 */
extern int SDL_SaveBMP_RW
		(SDL_Surface *surface, SDL_RWops *dst, int freedst);

/* Convenience macro -- save a surface to a file */
#define SDL_SaveBMP(surface, file) \
		SDL_SaveBMP_RW(surface, SDL_RWFromFile(file, "wb"), 1)

/*
 * Sets the color key (transparent pixel) in a blittable surface.
 * If 'flag' is SDL_SRCCOLORKEY (optionally OR'd with SDL_RLEACCEL), 
 * 'key' will be the transparent pixel in the source image of a blit.
 * SDL_RLEACCEL requests RLE acceleration for the surface if present,
 * and removes RLE acceleration if absent.
 * If 'flag' is 0, this function clears any current color key.
 * This function returns 0, or -1 if there was an error.
 */
extern int SDL_SetColorKey
			(SDL_Surface *surface, Uint32 flag, Uint32 key);

/*
 * This function sets the alpha value for the entire surface, as opposed to
 * using the alpha component of each pixel. This value measures the range
 * of transparency of the surface, 0 being completely transparent to 255
 * being completely opaque. An 'alpha' value of 255 causes blits to be
 * opaque, the source pixels copied to the destination (the default). Note
 * that per-surface alpha can be combined with colorkey transparency.
 *
 * If 'flag' is 0, alpha blending is disabled for the surface.
 * If 'flag' is SDL_SRCALPHA, alpha blending is enabled for the surface.
 * OR:ing the flag with SDL_RLEACCEL requests RLE acceleration for the
 * surface; if SDL_RLEACCEL is not specified, the RLE accel will be removed.
 */
extern int SDL_SetAlpha(SDL_Surface *surface, Uint32 flag, Uint8 alpha);

/*
 * Sets the clipping rectangle for the destination surface in a blit.
 *
 * If the clip rectangle is NULL, clipping will be disabled.
 * If the clip rectangle doesn't intersect the surface, the function will
 * return SDL_FALSE and blits will be completely clipped.  Otherwise the
 * function returns SDL_TRUE and blits to the surface will be clipped to
 * the intersection of the surface area and the clipping rectangle.
 *
 * Note that blits are automatically clipped to the edges of the source
 * and destination surfaces.
 */
extern SDL_bool SDL_SetClipRect(SDL_Surface *surface, SDL_Rect *rect);

/*
 * Gets the clipping rectangle for the destination surface in a blit.
 * 'rect' must be a pointer to a valid rectangle which will be filled
 * with the correct values.
 */
extern void SDL_GetClipRect(SDL_Surface *surface, SDL_Rect *rect);

/*
 * Creates a new surface of the specified format, and then copies and maps 
 * the given surface to it so the blit of the converted surface will be as 
 * fast as possible.  If this function fails, it returns NULL.
 *
 * The 'flags' parameter is passed to SDL_CreateRGBSurface() and has those 
 * semantics.  You can also pass SDL_RLEACCEL in the flags parameter and
 * SDL will try to RLE accelerate colorkey and alpha blits in the resulting
 * surface.
 *
 * This function is used internally by SDL_DisplayFormat().
 */
extern SDL_Surface *SDL_ConvertSurface
			(SDL_Surface *src, SDL_PixelFormat *fmt, Uint32 flags);

/*
 * This performs a fast blit from the source surface to the destination
 * surface.  It assumes that the source and destination rectangles are
 * the same size.  If either 'srcrect' or 'dstrect' are NULL, the entire
 * surface (src or dst) is copied.  The final blit rectangles are saved
 * in 'srcrect' and 'dstrect' after all clipping is performed.
 * If the blit is successful, it returns 0, otherwise it returns -1.
 *
 * The blit function should not be called on a locked surface.
 *
 * The blit semantics for surfaces with and without alpha and colorkey
 * are defined as follows:
 *
 * RGBA->RGB:
 *     SDL_SRCALPHA set:
 * 	alpha-blend (using alpha-channel).
 * 	SDL_SRCCOLORKEY ignored.
 *     SDL_SRCALPHA not set:
 * 	copy RGB.
 * 	if SDL_SRCCOLORKEY set, only copy the pixels matching the
 * 	RGB values of the source colour key, ignoring alpha in the
 * 	comparison.
 * 
 * RGB->RGBA:
 *     SDL_SRCALPHA set:
 * 	alpha-blend (using the source per-surface alpha value);
 * 	set destination alpha to opaque.
 *     SDL_SRCALPHA not set:
 * 	copy RGB, set destination alpha to opaque.
 *     both:
 * 	if SDL_SRCCOLORKEY set, only copy the pixels matching the
 * 	source colour key.
 * 
 * RGBA->RGBA:
 *     SDL_SRCALPHA set:
 * 	alpha-blend (using the source alpha channel) the RGB values;
 * 	leave destination alpha untouched. [Note: is this correct?]
 * 	SDL_SRCCOLORKEY ignored.
 *     SDL_SRCALPHA not set:
 * 	copy all of RGBA to the destination.
 * 	if SDL_SRCCOLORKEY set, only copy the pixels matching the
 * 	RGB values of the source colour key, ignoring alpha in the
 * 	comparison.
 * 
 * RGB->RGB: 
 *     SDL_SRCALPHA set:
 * 	alpha-blend (using the source per-surface alpha value).
 *     SDL_SRCALPHA not set:
 * 	copy RGB.
 *     both:
 * 	if SDL_SRCCOLORKEY set, only copy the pixels matching the
 * 	source colour key.
 *
 * If either of the surfaces were in video memory, and the blit returns -2,
 * the video memory was lost, so it should be reloaded with artwork and 
 * re-blitted:
	while ( SDL_BlitSurface(image, imgrect, screen, dstrect) == -2 ) {
		while ( SDL_LockSurface(image) < 0 )
			Sleep(10);
		-- Write image pixels to image->pixels --
		SDL_UnlockSurface(image);
	}
 * This happens under DirectX 5.0 when the system switches away from your
 * fullscreen application.  The lock will also fail until you have access
 * to the video memory again.
 */
/* You should call SDL_BlitSurface() unless you know exactly how SDL
   blitting works internally and how to use the other blit functions.
*/
//#define SDL_BlitSurface SDL_UpperBlit

/* This is the public blit function, SDL_BlitSurface(), and it performs
   rectangle validation and clipping before passing it to SDL_LowerBlit()
*/
extern int SDL_UpperBlit
			(SDL_Surface *src, SDL_Rect *srcrect,
			 SDL_Surface *dst, SDL_Rect *dstrect);
/* This is a semi-private blit function and it performs low-level surface
   blitting only.
*/
extern int SDL_LowerBlit
			(SDL_Surface *src, SDL_Rect *srcrect,
			 SDL_Surface *dst, SDL_Rect *dstrect);

/*
 * This function performs a fast fill of the given rectangle with 'color'
 * The given rectangle is clipped to the destination surface clip area
 * and the final fill rectangle is saved in the passed in pointer.
 * If 'dstrect' is NULL, the whole surface will be filled with 'color'
 * The color should be a pixel of the format used by the surface, and 
 * can be generated by the SDL_MapRGB() function.
 * This function returns 0 on success, or -1 on error.
 */
extern int SDL_FillRect
		(SDL_Surface *dst, SDL_Rect *dstrect, Uint32 color);

/* 
 * This function takes a surface and copies it to a new surface of the
 * pixel format and colors of the video framebuffer, suitable for fast
 * blitting onto the display surface.  It calls SDL_ConvertSurface()
 *
 * If you want to take advantage of hardware colorkey or alpha blit
 * acceleration, you should set the colorkey and alpha value before
 * calling this function.
 *
 * If the conversion fails or runs out of memory, it returns NULL
 */
extern SDL_Surface * SDL_DisplayFormat(SDL_Surface *surface);

/* 
 * This function takes a surface and copies it to a new surface of the
 * pixel format and colors of the video framebuffer (if possible),
 * suitable for fast alpha blitting onto the display surface.
 * The new surface will always have an alpha channel.
 *
 * If you want to take advantage of hardware colorkey or alpha blit
 * acceleration, you should set the colorkey and alpha value before
 * calling this function.
 *
 * If the conversion fails or runs out of memory, it returns NULL
 */
extern SDL_Surface * SDL_DisplayFormatAlpha(SDL_Surface *surface);


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* YUV video surface overlay functions                                       */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/* This function creates a video output overlay
   Calling the returned surface an overlay is something of a misnomer because
   the contents of the display surface underneath the area where the overlay
   is shown is undefined - it may be overwritten with the converted YUV data.
*/
extern SDL_Overlay *SDL_CreateYUVOverlay(int width, int height,
				Uint32 format, SDL_Surface *display);

/* Lock an overlay for direct access, and unlock it when you are done */
extern int SDL_LockYUVOverlay(SDL_Overlay *overlay);
extern void SDL_UnlockYUVOverlay(SDL_Overlay *overlay);

/* Blit a video overlay to the display surface.
   The contents of the video surface underneath the blit destination are
   not defined.  
   The width and height of the destination rectangle may be different from
   that of the overlay, but currently only 2x scaling is supported.
*/
extern int SDL_DisplayYUVOverlay(SDL_Overlay *overlay, SDL_Rect *dstrect);

/* Free a video overlay */
extern void SDL_FreeYUVOverlay(SDL_Overlay *overlay);


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* OpenGL support functions.                                                 */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/*
 * Dynamically load a GL driver, if SDL is built with dynamic GL.
 *
 * SDL links normally with the OpenGL library on your system by default,
 * but you can compile it to dynamically load the GL driver at runtime.
 * If you do this, you need to retrieve all of the GL functions used in
 * your program from the dynamic library using SDL_GL_GetProcAddress().
 *
 * This is disabled in default builds of SDL.
 */
extern int SDL_GL_LoadLibrary(const char *path);

/*
 * Get the address of a GL function (for extension functions)
 */
extern void *SDL_GL_GetProcAddress(const char* proc);

/*
 * Set an attribute of the OpenGL subsystem before intialization.
 */
extern int SDL_GL_SetAttribute(SDL_GLattr attr, int value);

/*
 * Get an attribute of the OpenGL subsystem from the windowing
 * interface, such as glX. This is of course different from getting
 * the values from SDL's internal OpenGL subsystem, which only
 * stores the values you request before initialization.
 *
 * Developers should track the values they pass into SDL_GL_SetAttribute
 * themselves if they want to retrieve these values.
 */
extern int SDL_GL_GetAttribute(SDL_GLattr attr, int* value);

/*
 * Swap the OpenGL buffers, if double-buffering is supported.
 */
extern void SDL_GL_SwapBuffers(void);

/*
 * Internal functions that should not be called unless you have read
 * and understood the source code for these functions.
 */
extern void SDL_GL_UpdateRects(int numrects, SDL_Rect* rects);
extern void SDL_GL_Lock(void);
extern void SDL_GL_Unlock(void);

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* These functions allow interaction with the window manager, if any.        */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/*
 * Sets/Gets the title and icon text of the display window
 */
extern void SDL_WM_SetCaption(const char *title, const char *icon);
extern void SDL_WM_GetCaption(char **title, char **icon);

/*
 * Sets the icon for the display window.
 * This function must be called before the first call to SDL_SetVideoMode().
 * It takes an icon surface, and a mask in MSB format.
 * If 'mask' is NULL, the entire icon surface will be used as the icon.
 */
extern void SDL_WM_SetIcon(SDL_Surface *icon, Uint8 *mask);

/*
 * This function iconifies the window, and returns 1 if it succeeded.
 * If the function succeeds, it generates an SDL_APPACTIVE loss event.
 * This function is a noop and returns 0 in non-windowed environments.
 */
extern int SDL_WM_IconifyWindow(void);

/*
 * Toggle fullscreen mode without changing the contents of the screen.
 * If the display surface does not require locking before accessing
 * the pixel information, then the memory pointers will not change.
 *
 * If this function was able to toggle fullscreen mode (change from 
 * running in a window to fullscreen, or vice-versa), it will return 1.
 * If it is not implemented, or fails, it returns 0.
 *
 * The next call to SDL_SetVideoMode() will set the mode fullscreen
 * attribute based on the flags parameter - if SDL_FULLSCREEN is not
 * set, then the display will be windowed by default where supported.
 *
 * This is currently only implemented in the X11 video driver.
 */
extern int SDL_WM_ToggleFullScreen(SDL_Surface *surface);

/*
 * This function allows you to set and query the input grab state of
 * the application.  It returns the new input grab state.
 */
typedef enum {
	SDL_GRAB_QUERY = -1,
	SDL_GRAB_OFF = 0,
	SDL_GRAB_ON = 1,
	SDL_GRAB_FULLSCREEN	/* Used internally */
} SDL_GrabMode;
/*
 * Grabbing means that the mouse is confined to the application window,
 * and nearly all keyboard input is passed directly to the application,
 * and not interpreted by a window manager, if any.
 */
extern SDL_GrabMode SDL_WM_GrabInput(SDL_GrabMode mode);


/* Printable format: "%d.%d.%d", MAJOR, MINOR, PATCHLEVEL
*/
#define SDL_MAJOR_VERSION	1
#define SDL_MINOR_VERSION	2
#define SDL_PATCHLEVEL		2



typedef struct FILE {
} FILE;


/* This is the read/write operation structure -- very basic */

typedef struct SDL_RWops {
} SDL_RWops;


/* Functions to create SDL_RWops structures from various data sources */

extern SDL_RWops * SDL_RWFromFile(const char *file, const char *mode);

extern SDL_RWops * SDL_RWFromFP(FILE *fp, int autoclose);

extern SDL_RWops * SDL_RWFromMem(void *mem, int size);

extern SDL_RWops * SDL_AllocRW(void);
extern void SDL_FreeRW(SDL_RWops *area);

/* Macros to easily read and write from an SDL_RWops structure */
#define SDL_RWseek(ctx, offset, whence)	(ctx)->seek(ctx, offset, whence)
#define SDL_RWtell(ctx)			(ctx)->seek(ctx, 0, SEEK_CUR)
#define SDL_RWread(ctx, ptr, size, n)	(ctx)->read(ctx, ptr, size, n)
#define SDL_RWwrite(ctx, ptr, size, n)	(ctx)->write(ctx, ptr, size, n)
#define SDL_RWclose(ctx)		(ctx)->close(ctx)





/*
#include "SDL_rwops.h" ???
#include "SDL_audio.h" really we want SDL_mixer interface.
#include "SDL_cdrom.h" later...
#include "SDL_byteorder.h" hm...
*/



/* These are the flags which may be passed to SDL_Init() -- you should
   specify the subsystems which you will be using in your application.
*/
#define	SDL_INIT_TIMER		0x00000001
#define SDL_INIT_AUDIO		0x00000010
#define SDL_INIT_VIDEO		0x00000020
#define SDL_INIT_CDROM		0x00000100
#define SDL_INIT_JOYSTICK	0x00000200
#define SDL_INIT_NOPARACHUTE	0x00100000	/* Don't catch fatal signals */
#define SDL_INIT_EVENTTHREAD	0x01000000	/* Not supported on all OS's */
#define SDL_INIT_EVERYTHING	0x0000FFFF

/* This function loads the SDL dynamically linked library and initializes 
 * the subsystems specified by 'flags' (and those satisfying dependencies)
 * Unless the SDL_INIT_NOPARACHUTE flag is set, it will install cleanup
 * signal handlers for some commonly ignored fatal signals (like SIGSEGV)
 */
extern int SDL_Init(Uint32 flags);

/* This function initializes specific SDL subsystems */
extern int SDL_InitSubSystem(Uint32 flags);

/* This function cleans up specific SDL subsystems */
extern void SDL_QuitSubSystem(Uint32 flags);

/* This function returns mask of the specified subsystems which have
   been initialized.
   If 'flags' is 0, it returns a mask of all initialized subsystems.
*/
extern Uint32 SDL_WasInit(Uint32 flags);

/* This function cleans up all initialized subsystems and unloads the
 * dynamically linked library.  You should call it upon all exit conditions.
 */
extern void SDL_Quit(void);

/* Ends C function definitions when using C++ */