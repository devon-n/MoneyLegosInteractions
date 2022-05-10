pragma solidity ^0.5.0

import "@studydefi/money-legos/kyber/contracts/KyberNetworkProxy.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract KyberLiteBase {
    // UNiswap factory address
    address constant KyberNetworkProxyAddress = "0x818E6FECD516Ecc3849DAf6845e3EC868087B755";

    function _ethToToken(address tokenAddress, uint ethAmount) internal returns (uint) {
        return _ethToToken(tokenAddress, ethAmount, uint(1));
    }

    function _ethToToken(address tokenAddress, uint ethAmount, uint minConversionRate) internal returns (uint) {
        IERC20 token = IERC20(tokenAddress);
        return KyberNetworkProxy(KyberNetworkProxyAddress).swapEtherToToken.value(ethAmount)(token, minConversionRate);
    }

    function _tokenToEth(address tokenAddress, uint tokenAmount) internal returns (uint) {
        return _tokenToEth(tokenAddress, tokenAmount, uint(1));
    }

    function _tokenToEth(address tokenAddress, uint tokenAmount, uint minConversionRate) internal returns (uint) {
        // Init Kyber
        KyberNetworkProxy kyber = KyberNetworkProxy(KyberNetworkProxyAddress);
        // Approve kyber to transfer
        IERC20(from).approve(address(kyber), tokenAmount);
        return kyber.swapTokenToToken(IERC20(from), tokenAmount, ERC20(to), minConversionRate);

    }

    function _tokenToToken(address from, address to, uint tokenAmount) internal returns (uint) {
        return _tokenToToken(from, to, tokenAmount, uint(1));
    }

    // Public functions
    function ethToToken(address tokenAddress) public payable {
        IERC20 token = IERC20(tokenAddress);
        uint tokensAmount = _ethToToken(tokenAddress, msg.value, uint(1));
        token.transfer(msg.sender, tokensAmount);
    }

    function tokenToToken(address fromToken, address toToken, address toAddress, uint tokenAmount) public payable {
        // Pointers to the two tokens
        IERC20 toToken = IERC20(toToken);
        IERC20 fromToken = IERC20(fromToken);
        //token.transfer
        fromToken.transfer(msg.sender, tokenAmount)
    }
}