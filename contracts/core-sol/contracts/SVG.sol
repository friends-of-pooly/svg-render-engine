// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { Base64 } from "base64-sol/base64.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { svg } from "./libraries/svg.sol";
import { svgUtils } from "./libraries/SVGUtils.sol";
import { SVGColor } from "./SVGColor.sol";
import { WidgetRouter } from "./WidgetRouter.sol";

contract SVG is Ownable {
  using Strings for uint256;
  address internal _svgColor;
  address internal _widgetRouter;

  constructor(address _widgetRouter_) {
    _widgetRouter = _widgetRouter_;
  }

  function render() public view returns (string memory) {
    string memory _bgDef = svgUtils.getDefURL("charocoal");
    bytes32 _defId = keccak256("DEFINITIONS");
    string memory _defs = WidgetRouter(_widgetRouter).fetch(_defId, bytes(abi.encodePacked("0x")));

    return
      string(
        abi.encodePacked(
          svg.start(),
          _defs,
          svg.rect(
            string.concat(
              svg.prop("fill", _bgDef),
              svg.prop("x", "0"),
              svg.prop("y", "0"),
              svg.prop("width", "100%"),
              svg.prop("height", "100%")
            ),
            svgUtils.NULL
          ),
          svg.text(
            string.concat(
              svg.prop("x", "50%"),
              svg.prop("y", "50%"),
              svg.prop("dominant-baseline", "middle"),
              svg.prop("text-anchor", "middle"),
              svg.prop("font-size", "48px"),
              svg.prop("fill", "white")
            ),
            string.concat("SVG")
          ),
          svg.end()
        )
      );
  }
}
