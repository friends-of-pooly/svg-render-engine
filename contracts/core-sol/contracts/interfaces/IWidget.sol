// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

interface IWidget {
  function fetch(bytes memory input) external view returns (string memory);
}
