import hre from "hardhat";
import { runHelloEthernautModule } from "./helloEthernaut.js";


async function main() {
    const connection = await hre.network.connect();
    runHelloEthernautModule(connection);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});