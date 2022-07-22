// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import { Base64 } from "base64-sol/base64.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { svg } from "./libraries/SVG.sol";
import { svgUtils } from "./libraries/SVGUtils.sol";
import { SVGColor } from "./libraries/SVGColor.sol";

contract SVGRender is Ownable {
  using Strings for uint256;
  address internal _svgColor;

  constructor(address _svgColor_) {
    _svgColor = _svgColor_;
  }

  function generate(string calldata colorDef) public view returns (string memory) {
    string memory _bgDef = svgUtils.getDefURL(colorDef);

    return
      string(
        abi.encodePacked(
          svg.start(),
          _getDefs(),
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

  function _getDefs() internal view returns (string memory) {
    return
      svg.defs(
        string.concat(
          svg.linearGradient(
            string.concat(svg.prop("id", "charcoal"), svg.prop("gradientTransform", "rotate(140)")),
            string.concat(
              svg.stop(
                string.concat(
                  svg.prop("offset", "0%"),
                  svg.prop("stop-color", SVGColor(_svgColor).getRgba("Dark1"))
                )
              ),
              svg.stop(
                string.concat(
                  svg.prop("offset", "70%"),
                  svg.prop("stop-color", SVGColor(_svgColor).getRgba("Dark2"))
                )
              )
            )
          )
        )
      );
  }
}
