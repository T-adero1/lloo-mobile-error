// @TODO: #med-p - Get this in a .env type setup
import 'package:magic_sdk/modules/web3/eth_network.dart';

//=======================================================================
// 3RD PARTY APIs
//=======================================================================

// MAGIC
const kConfigMagicApiKey = 'pk_live_7164BAE04E8A3470';
const kConfigMagicEthNetwork = 'goerli';

// LEONARDO (avatar image)
const kConfigLeonardoApiKey = '191779b3-c307-4818-9f99-c825b63022be';
const kConfigLeonardoModelId = "aa77f04e-3eec-4034-9c07-d0f619684628"; // Leonardo Kino XL
const kConfigLeonardoCharacterStrength = 1.2;
const kConfigLeonardoPrompt = "A headshot of a character ten years younger on a plain background. Transform to either a human / creature / animal / alien or something else. Make it look understated futurist and attractive.";

// const kConfigLeonardoPrompt = "A character on a plain background. can be human, creature, animal or something else. you can go wild on your interpretation.";

//=======================================================================
// LLOO APP INTERNALS
//=======================================================================

/// How many decimals to print for ATTN prices
const kConfigAttnDecimalPlacesToPrint = 3;

// @TODO: #low-p - Move firebase_options.dart stuff here?