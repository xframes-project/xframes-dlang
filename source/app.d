import std.stdio;
import asdf;
import std.array;
import std.conv;

enum ImGuiCol {
    Text,
    TextDisabled,
    WindowBg,
    ChildBg,
    PopupBg,
    Border,
    BorderShadow,
    FrameBg,
    FrameBgHovered,
    FrameBgActive,
    TitleBg,
    TitleBgActive,
    TitleBgCollapsed,
    MenuBarBg,
    ScrollbarBg,
    ScrollbarGrab,
    ScrollbarGrabHovered,
    ScrollbarGrabActive,
    CheckMark,
    SliderGrab,
    SliderGrabActive,
    Button,
    ButtonHovered,
    ButtonActive,
    Header,
    HeaderHovered,
    HeaderActive,
    Separator,
    SeparatorHovered,
    SeparatorActive,
    ResizeGrip,
    ResizeGripHovered,
    ResizeGripActive,
    Tab,
    TabHovered,
    TabActive,
    TabUnfocused,
    TabUnfocusedActive,
    PlotLines,
    PlotLinesHovered,
    PlotHistogram,
    PlotHistogramHovered,
    TableHeaderBg,
    TableBorderStrong,
    TableBorderLight,
    TableRowBg,
    TableRowBgAlt,
    TextSelectedBg,
    DragDropTarget,
    NavHighlight,
    NavWindowingHighlight,
    NavWindowingDimBg,
    ModalWindowDimBg,
    COUNT,
}

struct HEXA {
    string color;
    float alpha;

	void serialize(HEXA)(ref HEXA serializer)
    {
        auto state = serializer.listBegin();
		serializer.elemBegin; serializer.putValue(color);
		serializer.elemBegin; serializer.putValue(alpha);
        serializer.listEnd(state);
    }
}

struct ThemeColors {
    string[string] colors;
}

struct Theme {
    HEXA[ImGuiCol] colors;

	void serialize(Theme)(ref Theme serializer)
    {
        auto state = serializer.structBegin();

		foreach (key, hexa; this.colors)
        {
            serializer.putKey(to!string(to!int(key)));
			hexa.serialize(serializer);
        }
		
        serializer.structEnd(state);
    }
}

struct FontDef {
    string name;
    int size;
}

struct FontDefs {
    FontDef[] defs;
}

extern(C) {
	alias OnInitCb = void function();
	alias OnTextChangedCb = void function(int, const(char)*);
	alias OnComboChangedCb = void function(int, int);
	alias OnNumericValueChangedCb = void function(int, float);
	alias OnBooleanValueChangedCb = void function(int, bool);
	alias OnMultipleNumericValuesChangedCb = void function(int, const(float)*, int);
	alias OnClickCb = void function(int);

	void init(
        const(char)* assetsBasePath,
        const(char)* rawFontDefinitions,
        const(char)* rawStyleOverrideDefinitions,
        OnInitCb onInit,
        OnTextChangedCb onTextChanged,
        OnComboChangedCb onComboChanged,
        OnNumericValueChangedCb onNumericValueChanged,
        OnBooleanValueChangedCb onBooleanValueChanged,
        OnMultipleNumericValuesChangedCb onMultipleNumericValuesChanged,
        OnClickCb onClick
    );
}

version(Linux) {
    pragma(lib, "xframesshared.so");
}

version(Windows) {
    pragma(lib, "xframesshared.lib");
}

extern(C) void onInitCallback() {
    // writeln("Initialization complete!");
}

extern(C) void onTextChangedCallback(int id, const(char)* value) {
    writeln("Text changed: ", value);
}

extern(C) void onComboChangedCallback(int id, int value) {
    writeln("Combo changed: ", value);
}

extern(C) void onNumericValueChangedCallback(int id, float value) {
    writeln("Numeric value changed: ", value);
}

extern(C) void onBooleanValueChangedCallback(int id, bool value) {
    writeln("Boolean value changed: ", value);
}

extern(C) void onMultipleNumericValuesChangedCallback(int id, const(float)* values, int numValues) {
    writeln("Multiple numeric values changed: ");
    foreach (i; 0 .. numValues) {
        writeln(values[i]);
    }
}

extern(C) void onClickCallback(int id) {
    writeln("Button clicked: ", id);
}

void main()
{
	ThemeColors themeColors;
    
    themeColors.colors["darkestGrey"] = "#141f2c";
    themeColors.colors["darkerGrey"] = "#2a2e39";
    themeColors.colors["darkGrey"] = "#363b4a";
    themeColors.colors["lightGrey"] = "#5a5a5a";
    themeColors.colors["lighterGrey"] = "#7A818C";
    themeColors.colors["evenLighterGrey"] = "#8491a3";
    themeColors.colors["black"] = "#0A0B0D";
    themeColors.colors["green"] = "#75f986";
    themeColors.colors["red"] = "#ff0062";
    themeColors.colors["white"] = "#fff";

	auto themeColorsJson = themeColors.colors.serializeToJson();

	writeln(themeColorsJson);

	HEXA hexa = HEXA(themeColors.colors["white"], 1.0);

	auto hexaJson = hexa.serializeToJson();
	writeln(hexaJson);

	Theme theme;

	theme.colors[ImGuiCol.Text] = HEXA(themeColors.colors["white"], 1.0);
	theme.colors[ImGuiCol.TextDisabled] = HEXA(themeColors.colors["lighterGrey"], 1.0);
	theme.colors[ImGuiCol.WindowBg] = HEXA(themeColors.colors["black"], 1.0);
	theme.colors[ImGuiCol.ChildBg] = HEXA(themeColors.colors["black"], 1.0);
	theme.colors[ImGuiCol.PopupBg] = HEXA(themeColors.colors["white"], 1.0);
	theme.colors[ImGuiCol.Border] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.BorderShadow] = HEXA(themeColors.colors["darkestGrey"], 1.0);
	theme.colors[ImGuiCol.FrameBg] = HEXA(themeColors.colors["black"], 1.0);
	theme.colors[ImGuiCol.FrameBgHovered] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.FrameBgActive] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.TitleBg] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.TitleBgActive] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.TitleBgCollapsed] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.MenuBarBg] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.ScrollbarBg] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.ScrollbarGrab] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.ScrollbarGrabHovered] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.ScrollbarGrabActive] = HEXA(themeColors.colors["darkestGrey"], 1.0);
	theme.colors[ImGuiCol.CheckMark] = HEXA(themeColors.colors["darkestGrey"], 1.0);
	theme.colors[ImGuiCol.SliderGrab] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.SliderGrabActive] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.Button] = HEXA(themeColors.colors["black"], 1.0);
	theme.colors[ImGuiCol.ButtonHovered] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.ButtonActive] = HEXA(themeColors.colors["black"], 1.0);
	theme.colors[ImGuiCol.Header] = HEXA(themeColors.colors["black"], 1.0);
	theme.colors[ImGuiCol.HeaderHovered] = HEXA(themeColors.colors["black"], 1.0);
	theme.colors[ImGuiCol.HeaderActive] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.Separator] = HEXA(themeColors.colors["darkestGrey"], 1.0);
	theme.colors[ImGuiCol.SeparatorHovered] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.SeparatorActive] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.ResizeGrip] = HEXA(themeColors.colors["black"], 1.0);
	theme.colors[ImGuiCol.ResizeGripHovered] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.ResizeGripActive] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.Tab] = HEXA(themeColors.colors["black"], 1.0);
	theme.colors[ImGuiCol.TabHovered] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.TabActive] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.TabUnfocused] = HEXA(themeColors.colors["black"], 1.0);
	theme.colors[ImGuiCol.TabUnfocusedActive] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.PlotLines] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.PlotLinesHovered] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.PlotHistogram] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.PlotHistogramHovered] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.TableHeaderBg] = HEXA(themeColors.colors["black"], 1.0);
	theme.colors[ImGuiCol.TableBorderStrong] = HEXA(themeColors.colors["lightGrey"], 1.0);
	theme.colors[ImGuiCol.TableBorderLight] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.TableRowBg] = HEXA(themeColors.colors["darkGrey"], 1.0);
	theme.colors[ImGuiCol.TableRowBgAlt] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.TextSelectedBg] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.DragDropTarget] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.NavHighlight] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.NavWindowingHighlight] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.NavWindowingDimBg] = HEXA(themeColors.colors["darkerGrey"], 1.0);
	theme.colors[ImGuiCol.ModalWindowDimBg] = HEXA(themeColors.colors["darkerGrey"], 1.0);


	auto themeJson = theme.serializeToJson();

	writeln(themeJson);

	FontDefs fontDefs = FontDefs([
        FontDef("roboto-regular", 16),
        FontDef("roboto-regular", 18),
        FontDef("roboto-regular", 20),
        FontDef("roboto-regular", 24),
        FontDef("roboto-regular", 28),
        FontDef("roboto-regular", 32),
        FontDef("roboto-regular", 36),
        FontDef("roboto-regular", 48)
    ]);

	auto fontDefsJson = fontDefs.serializeToJson();

	writeln(fontDefsJson);

	string assetsBasePath = "./assets";
    string rawFontDefinitions = fontDefsJson;
    string rawStyleOverrideDefinitions = themeJson;

	init(
        assetsBasePath.ptr, 
        rawFontDefinitions.ptr, 
        rawStyleOverrideDefinitions.ptr,
        &onInitCallback,
        &onTextChangedCallback,
        &onComboChangedCallback,
        &onNumericValueChangedCallback,
        &onBooleanValueChangedCallback,
        &onMultipleNumericValuesChangedCallback,
        &onClickCallback
    );

	writeln("Yo");

	stdin.readf("d");
}
