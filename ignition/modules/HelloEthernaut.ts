import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


export function buildHelloEthernautModule(address: string) {
  return buildModule("HelloEthernautModule", (m) => {
    const helloEthernaut = m.contractAt("HelloEthernaut", address);
    m.call(helloEthernaut, "authenticate", ["7123949"]);
    return { helloEthernaut };
  })
}