using ILY;
using Love;

Boot.Init(new BootConfig() {
	WindowWidth = 1920,
	WindowHeight = 1080,
	WindowTitle = "ILY Editor",
	WindowVsync = false,
});

Boot.Run(new EditorWindow());