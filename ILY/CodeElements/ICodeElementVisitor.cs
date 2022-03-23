namespace ILY.CodeElements; 

public interface ICodeElementVisitor {
	public void Visit(RootElement rootElement);
	public void Visit(StructElement structElement);
	public void Visit(FunctionElement functionElement);
	public void Visit(FieldElement fieldElement);
	public void Visit(ArgumentElement argumentElement);
	public void Visit(VariableDeclarationElement variableDeclarationElement);
	public void Visit(ConstantExpressionElement constantExpressionElement);
	public void Visit(BinaryExpressionElement binaryExpressionElement);
	public void Visit(IfElement ifElement);
	public void Visit(ReturnElement returnElement);
	public void Visit(FunctionCallElement functionCallElement);
}