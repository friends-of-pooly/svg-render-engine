import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { Contract, ContractFactory } from 'ethers';
import { ethers } from 'hardhat';

const { getSigners, utils } = ethers;

describe('SVG', () => {
    let wallet0: SignerWithAddress;

    let SVG: Contract;
    let SVGLibrary: Contract;
    let SVGColor: Contract;
    let SVGRegistry: Contract;
    let SVGModuleDefinitions: Contract;
    let SVGUtilsFactory: ContractFactory;
    let svgFactory: ContractFactory;
    let SVGFactory: ContractFactory;
    let SVGSVGLibraryFactory: ContractFactory;
    let SVGColorFactory: ContractFactory;
    let SVGRegistryFactory: ContractFactory;
    let SVGModuleDefinitionsFactory: ContractFactory;

    before(async () => {
        [wallet0] = await getSigners();
        svgFactory = await ethers.getContractFactory('svg');
        SVGUtilsFactory = await ethers.getContractFactory('svgUtils');
        let svg = await svgFactory.deploy();
        let SVGUtils = await SVGUtilsFactory.deploy();
        SVGSVGLibraryFactory = await ethers.getContractFactory('SVGLibrary', {
            libraries: {
                svg: svg.address,
                svgUtils: SVGUtils.address
            }
        });
        SVGFactory = await ethers.getContractFactory('SVG');
        SVGColorFactory = await ethers.getContractFactory('SVGColor');
        SVGRegistryFactory = await ethers.getContractFactory('SVGRegistry');
        SVGModuleDefinitionsFactory = await ethers.getContractFactory('SVGModuleDefinitions');
    });

    beforeEach(async () => {
        SVGColor = await SVGColorFactory.deploy()
        SVGLibrary = await SVGSVGLibraryFactory.deploy(SVGColor.address)
        SVGModuleDefinitions = await SVGModuleDefinitionsFactory.deploy(SVGLibrary.address)
        SVGRegistry = await SVGRegistryFactory.deploy()
        SVGRegistry.setWidget(utils.keccak256(utils.toUtf8Bytes('DEFINITIONS')), SVGModuleDefinitions.address)
        SVG = await SVGFactory.deploy(SVGLibrary.address, SVGRegistry.address);
    });

    describe('render()', () => {
        it('should SUCCEED to generate an SVG', async () => {
            const svgString = '<svg width="400" height="400" style="background:#541563" viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg" ><defs ><linearGradient id="charcoal" gradientTransform="rotate(140)" ><stop offset="0%" stop-color="rgba(35,35,35,100%)" /><stop offset="70%" stop-color="rgba(70,70,70,100%)" /></linearGradient></defs><rect fill="" x="0" y="0" width="100%" height="100%" ></rect><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-size="48px" fill="white" >SVG</text></svg>'
            expect(await SVG.render()).to.be.equal(svgString);
        });
    });

});
