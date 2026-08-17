// HTML title screen, ported from Bubberstation (modular_skyrat/modules/title_screen),
// originally Gandalf2k15 & TauCeti. Rewritten against RT's APIs.

/// Fallback for how long a map takes to load, used to size the progress bar before we have real data.
#define TITLE_DEFAULT_LOADTIME (150 SECONDS)
/// Floor for the cached estimate. A too-small value divides the bar straight to 100% and sticks.
#define TITLE_MIN_LOADTIME (20 SECONDS)

/// Title art shown once we reach the lobby, when config supplies nothing.
#define TITLE_DEFAULT_SCREEN_IMAGE 'icons/title_static.png'

/// Where per-map load timings are cached between rounds.
#define TITLE_PROGRESS_CACHE_FILE "data/fenysha_title_progress.json"
/// Bump to invalidate every cached timing.
#define TITLE_PROGRESS_CACHE_VERSION "1"

/// Optional server-side override for the markup below.
#define TITLE_HTML_CONFIG_PATH "[global.config.directory]/fenysha/title_html.txt"

/// Browser resource name the title art is sent to the client under.
#define TITLE_IMAGE_RESOURCE "fenysha_title.png"

/// Skin element the page renders into. Declared in interface/skin.dmf.
#define TITLE_BROWSER_ID "title_browser"

// Everything up to and including <body>. Class names are a contract with the config override
// file and with title_screen_html.dm - renaming one breaks the screen.
#define TITLE_DEFAULT_HTML {"
	<html>
		<head>
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			<style type='text/css'>
				@font-face { font-family: "Newrocker"; src: url("newrocker.ttf"); }
				@font-face { font-family: "Pterra"; src: url("pterra.ttf"); }

				body, html {
					margin: 0;
					overflow: hidden;
					text-align: center;
					background-color: #000000;
					padding-top: 5vmin;
					-ms-user-select: none;
					cursor: default;
				}

				img {
					border-style: none;
					-webkit-user-drag: none;
					-ms-user-select: none;
					user-select: none;
				}

				/* pointer-events keeps the backdrop from swallowing clicks or being dragged
				   out of the window as a loose image. */
				.bg {
					position: absolute;
					width: auto;
					height: 100vmin;
					min-width: 100vmin;
					min-height: 100vmin;
					top: 50%;
					left: 50%;
					transform: translate(-50%, -50%);
					z-index: 0;
					pointer-events: none;
				}

				/* Anchored to the bottom so lines stack directly on top of the progress bar,
				   which occupies 3vmin to 7vmin. Auto height grows upward from there. */
				.container_terminal {
					position: absolute;
					width: 100%;
					max-height: calc(100% - 8vmin);
					overflow: hidden;
					box-sizing: border-box;
					padding: 0 2vmin 0.6vmin 2vmin;
					bottom: 7vmin;
					left: 0%;
					z-index: 1;
				}

				.terminal_text {
					display: block;
					font-family: "Pterra";
					font-weight: lighter;
					text-decoration: none;
					width: 100%;
					text-align: right;
					color: #c8a33c;
					text-shadow: 1px 1px black;
					margin: 0;
					font-size: 2vmin;
					line-height: 2.6vmin;
					letter-spacing: 1px;
				}

				.container_progress {
					position: absolute;
					box-sizing: border-box;
					bottom: 3vmin;
					left: 2vmin;
					height: 4vmin;
					width: calc(100% - 4vmin);
					border-left: 2px solid #c8a33c;
					border-right: 2px solid #c8a33c;
					padding: 4px;
					background-color: black;
				}

				.progress_bar { width: 0%; height: 100%; background-color: #c8a33c; }

				@keyframes fade_out { to { opacity: 0; } }
				.fade_out { animation: fade_out 2s both; }

				.container_nav {
					position: absolute;
					box-sizing: border-box;
					width: 90vmin;
					min-height: 10vmin;
					top: calc(50% + 22.5vmin);
					left: 50%;
					transform: translate(-50%, -50%);
					z-index: 1;
					border: 2px solid #6b5426;
					border-radius: 4px;
					box-shadow: 2px 2px #100c05, inset 1px 1px #100c05;
					background: linear-gradient(to bottom, rgba(32, 24, 12, 0.82), rgba(8, 6, 3, 0.88));
					padding: 1em;
				}

				.container_nav hr {
					height: 2px;
					background-color: #6b5426;
					border: none;
					box-shadow: 2px 2px black;
				}

				.menu_button {
					display: block;
					box-sizing: border-box;
					font-family: "Newrocker";
					font-weight: lighter;
					text-decoration: none;
					font-size: 4vmin;
					text-shadow: 2px 2px black;
					line-height: 4vmin;
					width: 100%;
					text-align: left;
					color: #d8c9a3;
					height: 4vmin;
					padding-left: 5vmin;
					letter-spacing: 1px;
					cursor: pointer;
					white-space: nowrap;
					overflow: hidden;
				}

				.menu_button:hover { padding-left: 0px; color: #f0c452; }
				.menu_button:active { padding-left: 0px; transform: translate(2px, 2px); }

				.menu_button:hover::before {
					content: "\\271D";
					text-align: center;
					width: 5vmin;
					display: inline-block;
				}

				@keyframes pulse_button {
					0% { transform: translateX(0px); }
					100% { transform: translateX(2px); }
				}

				.menu_button:active::before {
					content: "\\271D";
					text-align: center;
					width: 5vmin;
					animation: pulse_button 0.25s infinite alternate;
				}

				@keyframes pollsbox {
					0% { color: #d8c9a3; }
					50% { color: #f0c452; }
				}

				.menu_newpoll { animation: pollsbox 2s step-start infinite; padding-left: 0px; }
				.menu_newpoll::before { content: "\\2192"; text-align: center; width: 5vmin; display: inline-block; }
				.menu_newpoll::after { content: "\\2190"; text-align: center; width: 5vmin; display: inline-block; }

				.container_notice {
					position: absolute;
					box-sizing: border-box;
					width: auto;
					padding-top: 1vmin;
					top: calc(50% - 10vmin);
					left: 50%;
					transform: translate(-50%, -50%);
					z-index: 1;
				}

				.menu_notice {
					display: inline-block;
					font-family: "Newrocker";
					font-weight: lighter;
					text-decoration: none;
					width: 100%;
					text-align: left;
					color: #b32020;
					text-shadow: 1px 0px black, -1px 0px black, 0px 1px black, 0px -1px black, 2px 0px black, -2px 0px black, 0px 2px black, 0px -2px black;
					margin-right: 0%;
					margin-top: 0px;
					font-size: 3vmin;
					line-height: 2vmin;
				}

				.menu_status {
					display: block;
					font-family: "Newrocker";
					font-size: 2.6vmin;
					line-height: 3vmin;
					color: #9c8f70;
					text-shadow: 1px 1px black;
					text-align: center;
				}

				.unchecked { color: #b32020; }
				.checked { color: #6f9c3c; }
			</style>
		</head>
		<body>
			"}
