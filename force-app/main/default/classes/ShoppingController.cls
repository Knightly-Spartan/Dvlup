public class ShoppingController {
    public List<DisplayProduct> products{get;set;}
    public List<DisplayProduct> cart{get;set;}
    public Decimal Total{get;set;}
    public String prodIdChosen {get; set;}
    public String cartVal{get; set;}
	public Set<String> cartId = new Set<String>();
    public ShoppingController() { 
    	cartVal = 'Show Cart';		
   		products = new List<DisplayProduct>();
   		cart = new List<DisplayProduct>();
    	for(Product2 item : [SELECT Id, Name, Price__c 
       						 FROM Product2]) {
           	products.add(new DisplayProduct(item));
         }
    }
	
	public void addToCart() {
		for (DisplayProduct dp : products) {
			if (dp.id == prodIdChosen) {
				if(!cartId.contains(prodIdChosen)){
					dp.inCart = 'Yes';
					cart.add(dp);
					cartId.add(prodIdChosen);
				}
			}
		}
		if(cart.size()==1){
			cartVal = 'Show Cart ' + '(' +cart.size()+ ' product in cart)';
		}
		else
		{
			cartVal = 'Show Cart ' + '(' +cart.size()+ ' products in cart)';
		}
	}
	
	public void calcTotal()
	{
		Total = 0;
		for(DisplayProduct dp : cart)
		{
			Total += dp.price * dp.quantity;
		}
	}
	
	public PageReference goToCart()
	{
		calcTotal();
		PageReference pageRef = new PageReference('/apex/ShoppingCart');
	  	pageRef.setRedirect(false);
	  	return pageRef;  
	}
	
    public class DisplayProduct {
    	
        private Product2 prod;
        public DisplayProduct(Product2 item) {
            this.prod = item;
        }
		public String id {
            get { return prod.Id; }
        }
        public String name {
            get { return prod.Name; }
        }
        public Decimal price {
            get { return prod.Price__c; }
        }
        public Decimal stock {
			get { return prod.Stock__c; }
		}
        public Integer quantity { 
			get	{ 
				if(quantity == null)
					quantity = 1;
				return quantity; 
			}
			set	{ quantity = value; }	
		}
		public String inCart {
			get	{ 
				if(inCart == null)
					inCart = 'No';
				return inCart; 
			}
			set{ inCart = value; }
		}
		public Decimal subTotal { 
			get	{ return (quantity * price); }
		}
    }
}