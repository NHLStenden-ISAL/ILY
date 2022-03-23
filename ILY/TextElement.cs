using Love;

namespace ILY; 

public class TextElement {
	public string Text { get; set; }
	public Vector2 Position { get; set; }
	public Color Color { get; set; }

	public TextElement(string text, Vector2 position, Color color) {
		this.Text = text;
		this.Position = position;
		this.Color = color;
	}
}