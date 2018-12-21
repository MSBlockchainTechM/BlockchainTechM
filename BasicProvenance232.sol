    pragma solidity ^0.4.25;
contract WorkbenchBase {
    event WorkbenchContractCreated(string applicationName, string workflowName, address originatingAddress);
    event WorkbenchContractUpdated(string applicationName, string workflowName, string action, address originatingAddress);

    string internal ApplicationName;
    string internal WorkflowName;

    constructor(string applicationName, string workflowName) internal {
        ApplicationName = applicationName;
        WorkflowName = workflowName;
    }

    function ContractCreated() internal {
        emit WorkbenchContractCreated(ApplicationName, WorkflowName, msg.sender);
    }

    function ContractUpdated(string action) internal {
        emit WorkbenchContractUpdated(ApplicationName, WorkflowName, action, msg.sender);
    }
}

contract ProcureToPay is WorkbenchBase('ProcureToPay', 'ProcureToPay')
{

    //Set of States
	enum StateType 
    { CreateRFQ, CreatingRFQ,ReceivedRFQ,RequestPO
        ,RaisePO
        ,SendPO
        ,ConfirmPO    
    }
	
	//List of properties
	StateType public  State;
	address public  Supplier;
	address public  Vendor;
	address public  PreviousCounterparty;
	string public  ProductName;
	int public  OrderQuantity;
    int public Price;
    string public TargetedDeliveryDate;
	
	constructor(string ProductName, int OrderQuantity,int Price, string TargetedDeliveryDate) public
	{
        Supplier = msg.sender;
        Vendor = Supplier;
        ProductName = ProductName;
        OrderQuantity = OrderQuantity;
        Price=Price;
        TargetedDeliveryDate=TargetedDeliveryDate;
        State = StateType.CreateRFQ;  
        ContractCreated();
    }

	function CreatRequestForQuotation(address newCounterparty) public
	{
        if (Vendor != msg.sender)
        {
            revert();
        }

        if (State == StateType.CreateRFQ)
        {
            State = StateType.CreatingRFQ;
        }

        PreviousCounterparty = Vendor;
        Vendor = newCounterparty;
        ContractUpdated("CreatRequestForQuotation");
    }

    function ReceivedRequestForQuotation(address newCounterpartyAV) public
	{
              
        State = StateType.ReceivedRFQ;   

        
        Vendor = newCounterpartyAV;
        ContractUpdated("ReceivedRequestForQuotation");
    }

    function RequestPurchaseOrder(address newCounterpartyRequester) public
	{
              
        State = StateType.RequestPO;   

        
        Supplier = newCounterpartyRequester;
        ContractUpdated("RequestPurchaseOrder");
    }

    function RaisePurchaseOrder(address newCounterpartyRaiseReq) public
	{
              
        State = StateType.RaisePO;   

        
        Supplier = newCounterpartyRaiseReq;
        ContractUpdated("RaisePurchaseOrder");
    }

    function SendPurchaseOrder(address newCounterpartySendReq) public
	{
              
        State = StateType.SendPO;   

        
        Vendor = newCounterpartySendReq;
        ContractUpdated("SendPurchaseOrder");
    }

    function ConfirmPurchaseOrder(address newCounterpartyConfirmReq) public
	{
        State = StateType.ConfirmPO;   
        
        Supplier = newCounterpartyConfirmReq;
        ContractUpdated("ConfirmPurchaseOrder");        
        
    }

    
}