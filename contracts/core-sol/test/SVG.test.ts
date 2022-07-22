import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { Contract, ContractFactory } from 'ethers';
import { ethers } from 'hardhat';

const { getSigners, utils } = ethers;

describe('SVG', () => {
    let wallet0: SignerWithAddress;

    let SVG: Contract;
    let SVGColor: Contract;
    let WidgetRouter: Contract;
    let WidgetDefinitions: Contract;
    let SVGFactory: ContractFactory;
    let SVGColorFactory: ContractFactory;
    let WidgetRouterFactory: ContractFactory;
    let WidgetDefinitionsFactory: ContractFactory;

    before(async () => {
        [wallet0] = await getSigners();
        SVGFactory = await ethers.getContractFactory('SVG');
        SVGColorFactory = await ethers.getContractFactory('SVGColor');
        WidgetRouterFactory = await ethers.getContractFactory('WidgetRouter');
        WidgetDefinitionsFactory = await ethers.getContractFactory('WidgetDefinitions');
    });

    beforeEach(async () => {
        SVGColor = await SVGColorFactory.deploy()
        WidgetDefinitions = await WidgetDefinitionsFactory.deploy(SVGColor.address)
        WidgetRouter = await WidgetRouterFactory.deploy()
        WidgetRouter.setWidget(utils.keccak256(utils.toUtf8Bytes('DEFINITIONS')), WidgetDefinitions.address)
        SVG = await SVGFactory.deploy(WidgetRouter.address);
    });

    describe('render()', () => {
        it('should SUCCEED to generate an SVG', async () => {
            const svgString = '<svg width="400" height="400" style="background:#541563" viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg" ><defs ><linearGradient id="charcoal" gradientTransform="rotate(140)" ><stop offset="0%" stop-color="rgba(35,35,35,100%)" /><stop offset="70%" stop-color="rgba(70,70,70,100%)" /></linearGradient></defs><rect fill="url(#charocoal)" x="0" y="0" width="100%" height="100%" ></rect><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-size="48px" fill="white" >SVG</text></svg>'
            expect(await SVG.render()).to.be.equal(svgString);
        });
    });

});
