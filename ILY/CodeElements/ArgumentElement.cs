namespace ILY.CodeElements; 

public class ArgumentElement : ICodeElement {
	public ICodeElement Parent { get; set; }
	public string Identifier { get; set; }
	public string Type { get; set; }
	
	public ArgumentElement(ICodeElement parent, string identifier, string type) {
		this.Parent = parent;
		this.Identifier = identifier;
		this.Type = type;
	}
	
	public void Accept(ICodeElementVisitor visitor) {
		visitor.Visit(this);
	}
}