// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Pend Egyptian Pound (pEGP)
 * @notice Simple owner-controlled ERC-20 token pegged 1:1 to the Egyptian Pound.
 *         Only the contract owner can mint or burn.  No external dependencies.
 */
contract EGPStableCoin {
    /*//////////////////////////////////////////////////////////////
                               ERC-20 DATA
    //////////////////////////////////////////////////////////////*/
    string  public constant name     = "Pend Egyptian Pound";
    string  public constant symbol   = "pEGP";
    uint8   public constant decimals = 18;

    uint256 private _totalSupply;
    mapping(address => uint256)                     private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    /*//////////////////////////////////////////////////////////////
                                   ADMIN
    //////////////////////////////////////////////////////////////*/
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "pEGP: caller is not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "pEGP: zero address");
        owner = newOwner;
    }

    /*//////////////////////////////////////////////////////////////
                                 ERC-20 LOGIC
    //////////////////////////////////////////////////////////////*/
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256) { return _totalSupply; }
    function balanceOf(address account) external view returns (uint256) { return _balances[account]; }
    function allowance(address owner_, address spender) external view returns (uint256) { return _allowances[owner_][spender]; }

    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        uint256 curAllowance = _allowances[from][msg.sender];
        require(curAllowance >= amount, "pEGP: transfer amount exceeds allowance");
        unchecked { _approve(from, msg.sender, curAllowance - amount); }
        _transfer(from, to, amount);
        return true;
    }

    /*//////////////////////////////////////////////////////////////
                                MINT / BURN
    //////////////////////////////////////////////////////////////*/
    function mint(address to, uint256 amount) external onlyOwner {
        _totalSupply += amount;
        _balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    /*//////////////////////////////////////////////////////////////
                            INTERNAL HELPERS
    //////////////////////////////////////////////////////////////*/
    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0) && to != address(0), "pEGP: zero address");
        uint256 bal = _balances[from];
        require(bal >= amount, "pEGP: transfer amount exceeds balance");
        unchecked { _balances[from] = bal - amount; }
        _balances[to] += amount;
        emit Transfer(from, to, amount);
    }

    function _approve(address owner_, address spender, uint256 amount) internal {
        _allowances[owner_][spender] = amount;
        emit Approval(owner_, spender, amount);
    }

    function _burn(address from, uint256 amount) internal {
        uint256 bal = _balances[from];
        require(bal >= amount, "pEGP: burn amount exceeds balance");
        unchecked { _balances[from] = bal - amount; }
        _totalSupply -= amount;
        emit Transfer(from, address(0), amount);
    }
} 