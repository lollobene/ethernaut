import { NetworkConnection } from "hardhat/types/network";
import { buildHelloEthernautModule } from "../ignition/modules/HelloEthernaut.js";
import dotenv from "dotenv";

dotenv.config();
const HELLO_ETHERNAUT_ADDRESS = process.env.HELLO_ETHERNAUT_ADDRESS || "";

export function runHelloEthernautModule(connection: NetworkConnection) {
    if (HELLO_ETHERNAUT_ADDRESS === "") {
        throw new Error("HELLO_ETHERNAUT_ADDRESS is not set in the .ENV file");
    }
    buildHelloEthernautModule(HELLO_ETHERNAUT_ADDRESS);
}
