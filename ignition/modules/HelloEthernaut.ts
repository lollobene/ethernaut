import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export function buildHelloEthernautModule(address: string) {
  return buildModule("HelloEthernautModule", (m) => {
    const helloEthernaut = m.contractAt("HelloEthernaut", address);
    m.call(helloEthernaut, "authenticate", ["ethernaut0"]);
    return { helloEthernaut };
  })
}