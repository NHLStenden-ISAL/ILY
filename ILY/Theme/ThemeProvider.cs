namespace ILY.Theme; 

public class ThemeProvider {
	private readonly IReadOnlyList<ITheme> _themes = new List<ITheme>() {
		new ThemeOil(),
	};

	public ITheme CurrentTheme { get; set; }

	public ThemeProvider() {
		this.CurrentTheme = this._themes[0];
	}
}