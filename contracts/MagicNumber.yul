object "MagicNumberYUL" {
    code {
        let _1 := mload(64)
        codecopy(_1, dataoffset("MagicNumberYUL_deployed"), datasize("MagicNumberYUL_deployed"))
        return(_1, datasize("MagicNumberYUL_deployed"))
    }
    object "MagicNumberYUL_deployed" {
        code {            
            mstore(0, 0x2a)
            return(0, 32)
        }
    }
}