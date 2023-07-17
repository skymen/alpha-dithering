// WARNING: DO NOT EDIT THIS FILE, IT IS AUTOGENERATED
module.exports = {
  addonType: "effect",
  id: "effect_id",
  name: "My Effect",
  version: "1.0.0.0",
  category:
    // "blend",
    // "distortion",
    // "normal-mapping",
    // "tiling",
    // "other",
    "color",
  author: "skymen",
  website: "https://www.construct.net",
  documentation: "https://www.construct.net",
  description: "Description",
  supportedRenderers: ["webgl", "webgl2", "webgpu"],
  blendsBackground: false,
  usesDepth: false,
  crossSampling: false,
  preservesOpaqueness: false,
  animated: false,
  mustPredraw: false,
  extendBox: {
    horizontal: 1,
    vertical: 1,
  },
  isDeprecated: false,
  parameters: [
    /*
    {
      type:
        "float"
        "percent"
        "color"
      ,
      id: "property_id",
      value: 0,
      uniform: "uPropertyId",
      // precision: "lowp" // defaults to lowp if omitted
      interpolatable: true,
      name: "Property Name",
      desc: "Property Description",
    }
    */
    {
      type: "percent",
      id: "alphaDither",
      value: 1,
      uniform: "alphaDither",
      // precision: "lowp" // defaults to lowp if omitted
      interpolatable: true,
      name: "Alpha Dither",
      desc: "Amount of Alpha Dither to apply the image.",
    },
    {
      type: "float",
      id: "scale",
      value: 1,
      uniform: "scale",
      // precision: "lowp" // defaults to lowp if omitted
      interpolatable: true,
      name: "Scale",
      desc: "The pixel scale.",
    },
  ],
};
