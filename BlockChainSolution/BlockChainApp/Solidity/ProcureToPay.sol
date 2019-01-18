    pragma solidity ^0.4.25;

contract ProcureToPay
{

    //Set of States
	enum StateType { Created, CreatingContract,AcceptContract,ValidateGoods}
	
	//List of properties
	StateType public  State;
    address public  Buyer;
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
        State = StateType.Created;  
    }

	function CreatePurchaseOrder(address newCounterparty) public
	{
        if (Vendor != msg.sender)
        {
            revert();
        }

        if (State == StateType.Created)
        {
            State = StateType.CreatingContract;
        }

        PreviousCounterparty = Vendor;
        Vendor = newCounterparty;
        
    }

    function GetPurchaseOrderDetails(address newCounterpartyAV) public
	{
              
        State = StateType.AcceptContract;   

        
        Supplier = newCounterpartyAV;
        
    }

    function ValidateGoodsReceived(address newCounterpartyValidate) public
	{
              
        
    }

    function ConfirmPurchaseOrder(address newCounterpartyConfirm) public
	{
              
        
    }
    
    
}