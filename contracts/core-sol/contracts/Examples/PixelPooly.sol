// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { svg } from "../libraries/svg.sol";
import { SVGLibrary } from "../SVG/SVGLibrary.sol";
import { SVGRegistry } from "../SVGRegistry.sol";

contract PixelPooly is Ownable {
  address internal _svgLibrary;
  address internal _svgRegistry;

  bytes32 private immutable COLOR = keccak256("COLOR");
  bytes32 private immutable UTILS = keccak256("UTILS");
  bytes32 private immutable DEFINITIONS = keccak256("DEFINITIONS");
  bytes32 private immutable PIXEL_POOLY = keccak256("PIXEL_POOLY");

  constructor(address _svgLibrary_, address _svgRegistry_) {
    _svgLibrary = _svgLibrary_;
    _svgRegistry = _svgRegistry_;
  }

  function render(
    uint8 head,
    uint8 body,
    uint8 head_acc,
    uint8 body_acc,
    uint8 background
  ) public view returns (string memory) {
    string memory _svgBackgroundDefinition_ = SVGLibrary(_svgLibrary).execute(
      COLOR,
      abi.encodeWithSignature("getDefUrl(string)", "charocoal")
    );
    string memory _defs = SVGRegistry(_svgRegistry).fetch(
      DEFINITIONS,
      bytes(abi.encodePacked("0x"))
    );

    return
      string(
        abi.encodePacked(
          svg.start(),
          _defs,
          svg.rect(
            string.concat(
              svg.prop("fill", _svgBackgroundDefinition_),
              svg.prop("x", "0"),
              svg.prop("y", "0"),
              svg.prop("width", "100%"),
              svg.prop("height", "100%")
            ),
            _lib(UTILS, abi.encodeWithSignature("NULL(uint8)"))
          ),
          _registry(PIXEL_POOLY, abi.encode(uint8(1), head)),
          _registry(PIXEL_POOLY, abi.encode(uint8(2), body)),
          _registry(PIXEL_POOLY, abi.encode(uint8(3), head_acc)),
          _registry(PIXEL_POOLY, abi.encode(uint8(4), body_acc)),
          _registry(PIXEL_POOLY, abi.encode(uint8(5), background)),
          svg.end()
        )
      );
  }

  function _lib(bytes32 _key, bytes memory _value) internal view returns (string memory) {
    return SVGLibrary(_svgLibrary).execute(_key, _value);
  }

  function _registry(bytes32 _key, bytes memory _value) internal view returns (string memory) {
    return SVGRegistry(_svgRegistry).fetch(_key, _value);
  }
}
