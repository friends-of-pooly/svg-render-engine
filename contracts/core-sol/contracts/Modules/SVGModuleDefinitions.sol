// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { svg } from "../libraries/svg.sol";
import { svgUtils } from "../libraries/SVGUtils.sol";
import { ISVGModule } from "../interfaces/ISVGModule.sol";
import { SVGColor } from "../SVG/SVGColor.sol";
import { SVGLibrary } from "../SVG/SVGLibrary.sol";

contract SVGModuleDefinitions is ISVGModule, Ownable {
  SVGLibrary private _svgLibrary;

  bytes32 private immutable BUILD = keccak256("BUILD");
  bytes32 private immutable COLOR = keccak256("COLOR");
  bytes32 private immutable UTILS = keccak256("UTILS");

  constructor(address _svgLibrary_) {
    _svgLibrary = SVGLibrary(_svgLibrary_);
  }

  function fetch(bytes memory) external view override returns (string memory) {
    return _getDefs();
  }

  function getInterface() external view override returns (string memory) {
    return "";
  }

  function _color(string memory _sig, string memory _value) internal view returns (string memory) {
    return _svgLibrary.execute(COLOR, abi.encodeWithSignature(_sig, _value));
  }

  function _props(string memory _key, string memory _value) internal view returns (string memory) {
    return _svgLibrary.execute(BUILD, abi.encodeWithSignature("prop(string,string)", _key, _value));
  }

  function _getDefs() internal view returns (string memory) {
    return
      svg.defs(
        string.concat(
          svg.linearGradient(
            string.concat(_props("id", "charcoal"), _props("gradientTransform", "rotate(140)")),
            string.concat(
              svg.stop(
                string.concat(
                  _props("offset", "0%"),
                  _props("stop-Library", _color("getRgba(string)", "Dark1"))
                )
              ),
              svg.stop(
                string.concat(
                  _props("offset", "70%"),
                  _props("stop-Library", _color("getRgba(string)", "Dark2"))
                )
              )
            )
          )
        )
      );
  }
}
