namespace ILY.CodeElements; 

public class FunctionCallElement : ICodeElement {
	private readonly List<ICodeElement> _arguments;
	
	public ICodeElement Parent { get; set; }
	public string Identifier { get; set; }
	
	public FunctionCallElement(ICodeElement parent, string identifier) {
		this._arguments = new List<ICodeElement>();
		
		this.Parent = parent;
		this.Identifier = identifier;
	}
	
	public void AddArgument(ICodeElement argument, int position) {
		this._arguments.Insert(position, argument);
	}

	public void RemoveArgument(ICodeElement argument) {
		this._arguments.Remove(argument);
	}

	public IReadOnlyList<ICodeElement> GetArguments() {
		return this._arguments;
	}
	
	public void Accept(ICodeElementVisitor visitor) {
		visitor.Visit(this);
	}
}