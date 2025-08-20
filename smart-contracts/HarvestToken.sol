// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Harvest Token (HVT)
 * @notice ERC-20 LP token representing shares in the Harvest Pool. Only the
 *         HarvestPool contract (set as `owner`) can mint and burn tokens.
 */
contract HarvestToken {
    /*//////////////////////////////////////////////////////////////
                                ERC-20 DATA
    //////////////////////////////////////////////////////////////*/
    string  public constant name     = "Harvest Token";
    string  public constant symbol   = "HVT";
    uint8   public constant decimals = 18;

    uint256 private _totalSupply;
    mapping(address => uint256)                     private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    /*//////////////////////////////////////////////////////////////
                                   ADMIN
    //////////////////////////////////////////////////////////////*/
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "HVT: caller is not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "HVT: zero address");
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
        require(curAllowance >= amount, "HVT: transfer amount exceeds allowance");
        unchecked { _approve(from, msg.sender, curAllowance - amount); }
        _transfer(from, to, amount);
        return true;
    }

    /*//////////////////////////////////////////////////////////////
                               MINT / BURN (Owner-only)
    //////////////////////////////////////////////////////////////*/
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burnFrom(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }

    /*//////////////////////////////////////////////////////////////
                             INTERNAL HELPERS
    //////////////////////////////////////////////////////////////*/
    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0) && to != address(0), "HVT: zero address");
        uint256 bal = _balances[from];
        require(bal >= amount, "HVT: transfer amount exceeds balance");
        unchecked { _balances[from] = bal - amount; }
        _balances[to] += amount;
        emit Transfer(from, to, amount);
    }

    function _approve(address owner_, address spender, uint256 amount) internal {
        _allowances[owner_][spender] = amount;
        emit Approval(owner_, spender, amount);
    }

    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "HVT: zero address");
        _totalSupply += amount;
        _balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        uint256 bal = _balances[from];
        require(bal >= amount, "HVT: burn amount exceeds balance");
        unchecked { _balances[from] = bal - amount; }
        _totalSupply -= amount;
        emit Transfer(from, address(0), amount);
    }
} 