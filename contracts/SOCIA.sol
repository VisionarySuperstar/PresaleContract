// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return a / b;
  }
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}
library SafeMathInt {
    int256 private constant MIN_INT256 = int256(1) << 255;
    int256 private constant MAX_INT256 = ~(int256(1) << 255);

    function mul(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a * b;

        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
        require((b == 0) || (c / b == a));
        return c;
    }

    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != -1 || a != MIN_INT256);

        return a / b;
    }

    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));
        return c;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }

    function abs(int256 a) internal pure returns (int256) {
        require(a != MIN_INT256);
        return a < 0 ? -a : a;
    }
}
interface IPancakeSwapPair {
		event Approval(address indexed owner, address indexed spender, uint value);
		event Transfer(address indexed from, address indexed to, uint value);

		function name() external pure returns (string memory);
		function symbol() external pure returns (string memory);
		function decimals() external pure returns (uint8);
		function totalSupply() external view returns (uint);
		function balanceOf(address owner) external view returns (uint);
		function allowance(address owner, address spender) external view returns (uint);

		function approve(address spender, uint value) external returns (bool);
		function transfer(address to, uint value) external returns (bool);
		function transferFrom(address from, address to, uint value) external returns (bool);

		function DOMAIN_SEPARATOR() external view returns (bytes32);
		function PERMIT_TYPEHASH() external pure returns (bytes32);
		function nonces(address owner) external view returns (uint);

		function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

		event Mint(address indexed sender, uint amount0, uint amount1);
		event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
		event Swap(
				address indexed sender,
				uint amount0In,
				uint amount1In,
				uint amount0Out,
				uint amount1Out,
				address indexed to
		);
		event Sync(uint112 reserve0, uint112 reserve1);

		function MINIMUM_LIQUIDITY() external pure returns (uint);
		function factory() external view returns (address);
		function token0() external view returns (address);
		function token1() external view returns (address);
		function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
		function price0CumulativeLast() external view returns (uint);
		function price1CumulativeLast() external view returns (uint);
		function kLast() external view returns (uint);

		function mint(address to) external returns (uint liquidity);
		function burn(address to) external returns (uint amount0, uint amount1);
		function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
		function skim(address to) external;
		function sync() external;

		function initialize(address, address) external;
}

interface IPancakeSwapRouter{
		function factory() external pure returns (address);
		function WETH() external pure returns (address);

		function addLiquidity(
				address tokenA,
				address tokenB,
				uint amountADesired,
				uint amountBDesired,
				uint amountAMin,
				uint amountBMin,
				address to,
				uint deadline
		) external returns (uint amountA, uint amountB, uint liquidity);
		function addLiquidityETH(
				address token,
				uint amountTokenDesired,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline
		) external payable returns (uint amountToken, uint amountETH, uint liquidity);
		function removeLiquidity(
				address tokenA,
				address tokenB,
				uint liquidity,
				uint amountAMin,
				uint amountBMin,
				address to,
				uint deadline
		) external returns (uint amountA, uint amountB);
		function removeLiquidityETH(
				address token,
				uint liquidity,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline
		) external returns (uint amountToken, uint amountETH);
		function removeLiquidityWithPermit(
				address tokenA,
				address tokenB,
				uint liquidity,
				uint amountAMin,
				uint amountBMin,
				address to,
				uint deadline,
				bool approveMax, uint8 v, bytes32 r, bytes32 s
		) external returns (uint amountA, uint amountB);
		function removeLiquidityETHWithPermit(
				address token,
				uint liquidity,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline,
				bool approveMax, uint8 v, bytes32 r, bytes32 s
		) external returns (uint amountToken, uint amountETH);
		function swapExactTokensForTokens(
				uint amountIn,
				uint amountOutMin,
				address[] calldata path,
				address to,
				uint deadline
		) external returns (uint[] memory amounts);
		function swapTokensForExactTokens(
				uint amountOut,
				uint amountInMax,
				address[] calldata path,
				address to,
				uint deadline
		) external returns (uint[] memory amounts);
		function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
				external
				payable
				returns (uint[] memory amounts);
		function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
				external
				returns (uint[] memory amounts);
		function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
				external
				returns (uint[] memory amounts);
		function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
				external
				payable
				returns (uint[] memory amounts);

		function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
		function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
		function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
		function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
		function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
		function removeLiquidityETHSupportingFeeOnTransferTokens(
			address token,
			uint liquidity,
			uint amountTokenMin,
			uint amountETHMin,
			address to,
			uint deadline
		) external returns (uint amountETH);
		function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
			address token,
			uint liquidity,
			uint amountTokenMin,
			uint amountETHMin,
			address to,
			uint deadline,
			bool approveMax, uint8 v, bytes32 r, bytes32 s
		) external returns (uint amountETH);
	
		function swapExactTokensForTokensSupportingFeeOnTransferTokens(
			uint amountIn,
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external;
		function swapExactETHForTokensSupportingFeeOnTransferTokens(
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external payable;
		function swapExactTokensForETHSupportingFeeOnTransferTokens(
			uint amountIn,
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external;
}

interface IPancakeSwapFactory {
		event PairCreated(address indexed token0, address indexed token1, address pair, uint);

		function feeTo() external view returns (address);
		function feeToSetter() external view returns (address);

		function getPair(address tokenA, address tokenB) external view returns (address pair);
		function allPairs(uint) external view returns (address pair);
		function allPairsLength() external view returns (uint);

		function createPair(address tokenA, address tokenB) external returns (address pair);

		function setFeeTo(address) external;
		function setFeeToSetter(address) external;
}
contract SOCIA {
    using SafeMath for uint256;
    using SafeMathInt for int256;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) _isFeeExempt; // fees tax 
    string private _name = "SOCIA";
    string private _symbol = "SOCIA";
    address private ownerWallet;
    address private pairAddress;
    address private devWallet = 0x91F3A19A806A1484FcC7DB4278aD0CC4CA850084 ;
    address private marketingWallet = 0x91F3A19A806A1484FcC7DB4278aD0CC4CA850084;
    uint256 private _totalSupply;
    uint256 private _initailSupply ;
    uint256 private devPercentage = 1;
    uint256 private marketingPercentage = 2 ;
    uint256 private ownerPercentage = 3;
    uint256 private maxSupply = 80 * 10 ** decimals(); // 8000000000 = 8 billion
    uint256 private mintTime;
    uint256 private tiktok = 1 * 10 ** decimals();
    uint256 private facebook = 2 * 10 ** decimals();
    uint256 private instagram = 8  * 10 ** decimals();
    uint256 private tweeter = 18 * 10 ** decimals();
    bytes32 private sociaAuthentication = 0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC; // social Authentication
    bytes32 private rewardAuthentication = 0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC; // reward token authentication
    bytes32 private postAuthentication = 0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC; // post reward authentication
    bytes32 private referralAuthentication = 0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC; // referral reward authentication
    bool inSwap = false;
    bool private _autoAddLiquidity ;
    IPancakeSwapPair public pairContract;
    IPancakeSwapRouter public router;
    address private pair;
    uint256 private balanceParFragment;
    uint256 public constant MAX_UINT256 = ~uint256(0);
    uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % 112);
    uint256 private taxFee = 5;
    uint256 private _lastAddLiquidityTime;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
    constructor(uint256 _initial) {
        router = IPancakeSwapRouter(0xD99D1c33F9fC3444f8101754aBC46c52416550D1); 
        pair = IPancakeSwapFactory(router.factory()).createPair(
            router.WETH(),
            address(this)
        );
        _allowances[address(this)][address(router)] = type(uint128).max;
        pairAddress = pair;
        pairContract = IPancakeSwapPair(pair);
        _autoAddLiquidity = true;
        _isFeeExempt[ownerWallet] = true;
        _isFeeExempt[address(this)] = true;
        ownerWallet = msg.sender;
        _initial = _initial.mul(10 ** decimals());
        uint256 devAmount = (devPercentage.mul(_initial)).div(100);
        _mint(devWallet, devAmount);
        uint256 marketingAmount = (marketingPercentage.mul(_initial)).div(100);
        _mint(marketingWallet, marketingAmount);
        uint256 ownerAmount = (ownerPercentage.mul(_initial)).div(100);
        _mint(ownerWallet, ownerAmount);
        _totalSupply = (devAmount.add(marketingAmount)).add(ownerAmount);
        balanceParFragment = TOTAL_GONS.div(_totalSupply);
        mintTime = block.timestamp;
        _initailSupply = _initial;
    }
    modifier onlyOwner(){
        require(msg.sender ==  ownerWallet,"only owner can call");
        _;
    }
    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }
    function name() public view returns (string memory) {
        return _name;
    }
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    function decimals() public pure returns (uint8) {
        return 18;
    }
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) public view  returns (uint256) {
        return _balances[account];
    }
    function transfer(address to, uint256 value) public  returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(value >= _allowances[from][to],"insufficient allownce");
        decreaseAllowance(to, value);
        _transfer(from, to, value);
        return true;
    }
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, allowance(msg.sender, spender) + addedValue);
        return true;
    }
    function decreaseAllowance(address spender, uint256 requestedDecrease) public returns (bool) {
        uint256 currentAllowance = allowance(msg.sender, spender);
        unchecked {
            _approve(msg.sender, spender, currentAllowance - requestedDecrease);
        }
        return true;
    }
    function transferOwnership(address newOwnerWallet) public onlyOwner {
        require(newOwnerWallet != address(0));
        emit OwnershipTransferred(ownerWallet, newOwnerWallet);
        ownerWallet = newOwnerWallet;
    }
    function _transfer(address from, address to, uint256 value) internal {
        require(_balances[from] >= value,"insufficient value to transfer");
        if (inSwap) {
            _balances[from] -= value;
            _balances[to] +=value;
        }
        if (shouldAddLiquidity()) {
            addLiquidity();
        }

        if (shouldSwapBack()) {
            swapBack();
        }
        
        emit Transfer(from, to, value);
    }
    function _mint(address account, uint256 value) internal {
        require(account != address(0),"mint not possible to address 0x0");
        _balances[account] += value;
        _totalSupply += value;
        emit Transfer(address(0x0), account, value);
    }
    function _burn(address account, uint256 value) internal {
        require(account != address(0x0),"burn not possible");
        _balances[account] -= value;
        _totalSupply -= value;
        emit Transfer(account, address(0x0), value);
    }
    function _approve(address owner, address spender, uint256 value) internal {
        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }
    // function for owner mint after 30 days
    function ownerMint(uint256 value) public onlyOwner returns (bool){
       require(block.timestamp >= mintTime.add(2592000),"wait to complete 30 days");
       uint256 devAmount = (devPercentage.mul(value)).div(100);
       uint256 marketingAmount = (marketingPercentage.mul(value)).div(100);
       uint256 ownerAmount = (ownerPercentage.mul(value)).div(100);
       uint256 supply = devAmount.add(marketingAmount).add(ownerAmount);
       require (totalSupply().add(supply) <= maxSupply,"max supply 8 billion increasing" );
       _mint(devWallet, devAmount);
       _mint(marketingWallet, marketingAmount);
       _mint(ownerWallet, ownerAmount);
       return true;
    }
    // burn tokens 
    function burn(uint256 value) public returns(bool){
        _burn(msg.sender, value);
        return true;
    }
    // update the address and percentage of dev wallet which is call by only owner of token
    function updateDev(address _newDevAddress,uint256 newDevPercentage) public  onlyOwner returns (bool){
        devWallet = _newDevAddress;
        devPercentage = newDevPercentage;
        return true;
    }
    // update the address and percentage of marketing wallet which is call by only owner of token
    function updateMarketing(address _newMarketingAddress,uint256 newMarketingPercentage) public  onlyOwner returns (bool){
        marketingWallet = _newMarketingAddress;
        marketingPercentage = newMarketingPercentage;
        return true;
    }
    // update the percentage of owner wallet which is call by only owner of token
    function updateOwner(uint256 newOwnerPercentage) public  onlyOwner returns (bool){
        ownerPercentage = newOwnerPercentage;
        return true;
    }
    // socia Mint
    // tiktok 1000 likes = 1 token
    // facebook 1000 likes = 2 token
    // instagram 1000 likes = 8 token 
    // tweeter 1000 likes = 18 token
    function sociaMint(uint256 tokenAmount,bytes32 _sociaAuthentication) public returns(bool){
        require(_sociaAuthentication ==  sociaAuthentication," sociaAuthentication error");
        require(totalSupply().add(tokenAmount) <= maxSupply,"max supply limit is 8 billion");    
        _mint(msg.sender, tokenAmount);
        return true;
    }
    // update  sociaAuthentication phrase
    function updateSociaAuthentication(bytes32 _newsociaAuthentication) public onlyOwner returns(bool){
         sociaAuthentication = _newsociaAuthentication;
        return true;
    }
    // reward tokens by putting beneficier address , rewardTokens and authentication phrase 
    function rewardTokens(address beneficier,uint256 rewardToken,bytes32 _rewardAuthentication) public returns(bool){
        require(_rewardAuthentication == rewardAuthentication,"reward authentication error");
        require(totalSupply().add(rewardToken) <= maxSupply,"max supply limit is 8 billion");  
        _mint(beneficier, rewardToken);
        return true;
    }
    // update reward tokens authentication
    function updateRewardAuthentication(bytes32 _newrewardAuthentication) public onlyOwner returns(bool){
        rewardAuthentication = _newrewardAuthentication;
        return true;
    }
    // rewardTokens to post by putting beneficer address , rewardTokens and post authentication phrase
    function postTokens(address beneficier,uint256 postNumTokens,bytes32 _postAuthentication) public returns (bool){
        require(postAuthentication == _postAuthentication,"post authentication error");
        require(totalSupply().add(postNumTokens) <= maxSupply,"max supply limit is 8 billion"); 
        _mint(beneficier, postNumTokens);
        return true;
    }
    function updatePostAuthentication(bytes32 _newPostAuthentication) public onlyOwner returns (bool){
        postAuthentication = _newPostAuthentication;
        return true;
    }
    // referral reward tokens by putting referralar address , rewardTokens and referralar authentication
    function referral(address referralar,uint256 rewardToken,bytes32 _referralAuthentication) public returns(bool){
        require(_referralAuthentication == referralAuthentication,"referral authentication error");
        require(totalSupply().add(rewardToken) <= maxSupply,"max supply limit is 8 billion"); 
        _mint(referralar, rewardToken);
        return true;
    }
    function updateReferralAuthentication(bytes32 _newreferralAuthentication) public onlyOwner returns(bool){
        referralAuthentication = _newreferralAuthentication;
        return true;
    }
    receive() external payable {}
    function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
    function setPairAddress(address _pairAddress) public onlyOwner {
        pairAddress = _pairAddress;
    }

    function setLP(address _address) external onlyOwner {
        pairContract = IPancakeSwapPair(_address);
    }
    function addLiquidity() internal swapping {
        uint256 autoLiquidityAmount =  _balances[ownerWallet].div(
            balanceParFragment
        );
         _balances[address(this)] =  _balances[address(this)].add(
             _balances[ownerWallet]
        );
         _balances[ownerWallet] = 0;
        uint256 amountToLiquify = autoLiquidityAmount.div(2);
        uint256 amountToSwap = autoLiquidityAmount.sub(amountToLiquify);
        if( amountToSwap == 0 ) {
            return;
        }
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        uint256 balanceBefore = address(this).balance;
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );
        uint256 amountETHLiquidity = address(this).balance.sub(balanceBefore);
        if (amountToLiquify > 0&&amountETHLiquidity > 0) {
            router.addLiquidityETH{value: amountETHLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                ownerWallet,
                block.timestamp
            );
        }
        _lastAddLiquidityTime = block.timestamp;
    }
    function swapBack() internal swapping {
        uint256 amountToSwap =  _balances[address(this)].div(balanceParFragment);
        if( amountToSwap == 0) {
            return;
        }
        uint256 balanceBefore = address(this).balance;
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );
        uint256 amountETHToTreasuryAndSIF = address(this).balance.sub(
            balanceBefore
        );
        (bool success, ) = payable(ownerWallet).call{
            value: amountETHToTreasuryAndSIF.mul(taxFee).div(
                taxFee
            ),
            gas: 30000
        }("");
        (success, ) = payable(ownerWallet).call{
            value: amountETHToTreasuryAndSIF.mul(taxFee).div(
                taxFee
            ),
            gas: 30000
        }("");
    }

    function withdrawAllTo() external swapping onlyOwner {
        uint256 amountToSwap =  _balances[address(this)].div(balanceParFragment);
        require( amountToSwap > 0,"There is no Safuu token deposited in token contract");
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            ownerWallet,
            block.timestamp
        );
    }
    function manualSync() external {
        IPancakeSwapPair(pair).sync();
    }
    function shouldAddLiquidity() internal view returns (bool) {
        return
            _autoAddLiquidity && 
            !inSwap && 
            msg.sender != pair &&
            block.timestamp >= (_lastAddLiquidityTime + 2 days);
    }
    function setAutoAddLiquidity(bool _flag) external onlyOwner {
        if(_flag) {
            _autoAddLiquidity = _flag;
            _lastAddLiquidityTime = block.timestamp;
        } else {
            _autoAddLiquidity = _flag;
        }
    }
    function shouldSwapBack() internal view returns (bool) {
        return 
            !inSwap &&
            msg.sender != pair  ; 
    }
}