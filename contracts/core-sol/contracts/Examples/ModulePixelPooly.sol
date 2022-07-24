// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { svg } from "../libraries/svg.sol";
import { svgUtils } from "../libraries/SVGUtils.sol";
import { ISVGModule } from "../interfaces/ISVGModule.sol";
import { SVGLibrary } from "../SVG/SVGLibrary.sol";

contract ModulePixelPooly is ISVGModule, Ownable {
  SVGLibrary private _svgLibrary;

  string private _encoding = "(uint8, uint8)";
  bytes32 private constant immutable BUILD = keccak256("BUILD");
  bytes32 private constant immutable COLOR = keccak256("COLOR");
  bytes32 private constant immutable UTILS = keccak256("UTILS");

  mapping(uint8 => mapping(uint8 => string)) private _elements;

  constructor(address _svgLibrary_) {
    _svgLibrary = SVGLibrary(_svgLibrary_);
    _elements[1][1] = "HEAD_1";
    _elements[2][1] = "BODY_1";
    _elements[3][1] = "HEAD_ACC_1";
    _elements[4][1] = "BODY_ACC_1";
    _elements[5][1] = "BACKGROUND_1";
  }

  function fetch(bytes memory input) external view override returns (string memory) {
    return _generateHead(input);
  }

  function getEncoding() external view override returns (string memory) {
    return _encoding;
  }

  function getElement(uint8 element, uint8 position) external view returns (string memory) {
    return _elements[element][position];
  }

  function setElement(
    uint8 element,
    uint8 position,
    string memory svg
  ) external onlyOwner {
    _elements[element][position] = svg;
  }

  function _color(string memory _sig, string memory _value) internal view returns (string memory) {
    return _svgLibrary.execute(COLOR, abi.encodeWithSignature(_sig, _value));
  }

  function _props(string memory _key, string memory _value) internal view returns (string memory) {
    return _svgLibrary.execute(BUILD, abi.encodeWithSignature("prop(string,string)", _key, _value));
  }

  function _generateHead(bytes memory input) internal view returns (string memory) {
    (uint8 _pos, uint8 _head_) = abi.decode(input, (uint8, uint8));

    return
      svg.text(
        string.concat(
          svg.prop("x", "50%"),
          svg.prop("y", "20%"),
          svg.prop("width", "40%"),
          svg.prop("height", "40%")
        ),
        _elements[_pos][_head_]
      );
  }
}
