// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { svg } from "../libraries/svg.sol";
import { svgUtils } from "../libraries/SVGUtils.sol";
import { IWidget } from "../interfaces/IWidget.sol";
import { SVGColor } from "../SVGColor.sol";

contract WidgetDefinitions is IWidget, Ownable {
  address private _svgColor;

  constructor(address _svgColor_) {
    _svgColor = _svgColor_;
  }

  function fetch(bytes memory) external view override returns (string memory) {
    return _getDefs();
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
