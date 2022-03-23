using Love;

namespace ILY.Theme; 

public interface ITheme {
	public interface IThemeSyntax {
		public Color TextColor { get; }
		public Color IdentifierColor { get; }
		public Color KeywordStructColor { get; }
		public Color KeywordFunctionColor { get; }
		public Color KeywordVarColor { get; }
		public Color KeywordReturnColor { get; }
		public Color FieldColor { get; }
		public Color VariableColor { get; }
		public Color TypeColor { get; }
		public Color ConstantNumberColor { get; }
		public Color ConstantBooleanColor { get; }
		public Color ConstantStringColor { get; }
	}
	
	public Color BackgroundColor { get; }
	
	public IThemeSyntax Syntax { get; }
}

