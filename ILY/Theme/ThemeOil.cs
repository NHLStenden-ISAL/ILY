using Love;

namespace ILY.Theme;

public class ThemeOil : ITheme {
	private class ThemeSyntax : ITheme.IThemeSyntax {
		public Color TextColor { get; } = new Color(251, 245, 239, 255);
		public Color IdentifierColor { get; } = new Color(255, 255, 255, 255);
		public Color KeywordStructColor { get; } = new Color(104, 109, 168, 255);
		public Color KeywordFunctionColor { get; } = new Color(104, 109, 168, 255);
		public Color KeywordVarColor { get; } = new Color(104, 109, 168, 255);
		public Color KeywordReturnColor { get; } = new Color(104, 109, 168, 255);
		public Color FieldColor { get; } = new Color(198, 159, 165, 255);
		public Color VariableColor { get; } = new Color(198, 159, 165, 255);
		public Color TypeColor { get; } = new Color(242, 211, 171, 255);
		public Color ConstantNumberColor { get; } = new Color(242, 211, 171, 255);
		public Color ConstantBooleanColor { get; } = new Color(171, 211, 242, 255);
		public Color ConstantStringColor { get; } = new Color(211, 242, 171, 255);
	}
	
	public Color BackgroundColor { get; } = new Color(39, 39, 68, 255);
	public ITheme.IThemeSyntax Syntax { get; } = new ThemeSyntax();
}