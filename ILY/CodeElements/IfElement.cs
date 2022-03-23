namespace ILY.CodeElements; 

public class IfElement : ICodeElement {
	private readonly List<ICodeElement> _statements;
	public ICodeElement Parent { get; set; }
	public ICodeElement? Expression { get; set; }
	
	public IfElement(ICodeElement parent) {
		this._statements = new List<ICodeElement>();
		
		this.Parent = parent;
	}

	public void SetExpression(ICodeElement expression) {
		this.Expression = expression;
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