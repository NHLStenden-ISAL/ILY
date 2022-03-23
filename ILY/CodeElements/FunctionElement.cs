namespace ILY.CodeElements; 

public class FunctionElement : ICodeElement {
	private readonly List<ICodeElement> _statements;
	private readonly List<ICodeElement> _arguments;
	
	public ICodeElement Parent { get; set; }
	public string Identifier { get; set; }
	
	public FunctionElement(ICodeElement parent, string identifier) {
		this._statements = new List<ICodeElement>();
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
	
	public void AddStatement(ICodeElement statement, int position) {
		this._statements.Insert(position, statement);
	}

	public void RemoveStatement(ICodeElement statement) {
		this._statements.Remove(statement);
	}

	public IReadOnlyList<ICodeElement> GetStatements() {
		return this._statements;
	}
	
	public void Accept(ICodeElementVisitor visitor) {
		visitor.Visit(this);
	}
}