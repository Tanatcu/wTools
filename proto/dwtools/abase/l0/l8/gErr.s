(function _gErr_s_() {

'use strict';

let _ObjectHasOwnProperty = Object.hasOwnProperty;
let _global = _global_;
let _ = _global.wTools;
let _err = _._err;

// --
// diagnostics
// --

function diagnosticBeep()
{
  console.log( '\x07' );
}

//

/*

_.diagnosticWatchFields
({
  target : _global_,
  names : 'Uniforms',
});

_.diagnosticWatchFields
({
  target : state,
  names : 'filterColor',
});

_.diagnosticWatchFields
({
  target : _global_,
  names : 'Config',
});

_.diagnosticWatchFields
({
  target : _global_,
  names : 'logger',
});

_.diagnosticWatchFields
({
  target : self,
  names : 'catalogPath',
});

*/

function diagnosticWatchFields( o )
{

  if( arguments[ 1 ] !== undefined )
  o = { target : arguments[ 0 ], names : arguments[ 1 ] }
  o = _.routineOptions( diagnosticWatchFields, o );

  if( o.names )
  o.names = o.names;
  // o.names = _.nameFielded( o.names );
  else
  o.names = o.target;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectLike( o.target ) );
  _.assert( _.objectLike( o.names ) );

  for( let f in o.names ) ( function()
  {

    let fieldName = f;
    let fieldSymbol = Symbol.for( f );
    //o.target[ fieldSymbol ] = o.target[ f ];
    let val = o.target[ f ];

    /* */

    function read()
    {
      //let result = o.target[ fieldSymbol ];
      let result = val;
      if( o.verbosity > 1 )
      console.log( 'reading ' + fieldName + ' ' + _.toStr( result ) );
      else
      console.log( 'reading ' + fieldName );
      if( o.debugging > 1 )
      debugger;
      return result;
    }

    /* */

    function write( src )
    {
      if( o.verbosity > 1 )
      console.log( 'writing ' + fieldName + ' ' + _.toStr( o.target[ fieldName ] ) + ' -> ' + _.toStr( src ) );
      else
      console.log( 'writing ' + fieldName );
      if( o.debugging )
      debugger;
      //o.target[ fieldSymbol ] = src;
      val = src;
    }

    /* */

    if( o.debugging > 1 )
    debugger;

    if( o.verbosity > 1 )
    console.log( 'watching for', fieldName, 'in', o.target );
    Object.defineProperty( o.target, fieldName,
    {
      enumerable : true,
      configurable : true,
      get : read,
      set : write,
    });

  })();

}

diagnosticWatchFields.defaults =
{
  target : null,
  names : null,
  verbosity : 2,
  debugging : 1,
}

//

/*

_.diagnosticProxyFields
({
  target : _.field,
});

_.diagnosticWatchFields
({
  target : _,
  names : 'field',
});

*/

function diagnosticProxyFields( o )
{

  if( arguments[ 1 ] !== undefined )
  o = { target : arguments[ 0 ], names : arguments[ 1 ] }
  o = _.routineOptions( diagnosticWatchFields, o );

  // if( o.names )
  // o.names = _.nameFielded( o.names );

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectLike( o.target ) );
  _.assert( _.objectLike( o.names ) || o.names === null );

  let handler =
  {
    set : function( obj, k, e )
    {
      if( o.names && !( k in o.names ) )
      return;
      if( o.verbosity > 1 )
      console.log( 'writing ' + k + ' ' + _.toStr( o.target[ k ] ) + ' -> ' + _.toStr( e ) );
      else
      console.log( 'writing ' + k );
      if( o.debug )
      debugger;
      obj[ k ] = e;
      return true;
    }
  }

  let result = new Proxy( o.target, handler );
  if( o.verbosity > 1 )
  console.log( 'watching for', o.target );

  if( o.debug )
  debugger;

  return result;
}

diagnosticProxyFields.defaults =
{
}

diagnosticProxyFields.defaults.__proto__ == diagnosticWatchFields.defaults

//

function diagnosticEachLongType( o )
{
  let result = Object.create( null );

  if( _.routineIs( o ) )
  o = { onEach : o }
  o = _.routineOptions( diagnosticEachLongType, o );

  if( o.onEach === null )
  o.onEach = function onEach( make, descriptor )
  {
    return make;
  }

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.routineIs( o.onEach ) )

  // debugger;

  for( let l in _.LongDescriptors )
  {
    let Long = _.LongDescriptors[ l ];
    result[ Long.name ] = o.onEach( Long.make, Long );
  }

  // debugger;

  return result;
}

diagnosticEachLongType.defaults =
{
  onEach : null,
}

//

function diagnosticEachElementComparator( o )
{
  let result = [];

  if( arguments[ 1 ] !== undefined )
  o = { onMake : arguments[ 0 ], onEach : arguments[ 1 ] }
  else if( _.routineIs( arguments[ 0 ] ) )
  o = { onEach : arguments[ 1 ] }

  o = _.routineOptions( diagnosticEachElementComparator, o );

  if( o.onEach === null )
  o.onEach = function onEach( make, evaluate, description )
  {
    return evaluate;
  }

  if( o.onMake === null )
  o.onMake = function onMake( src )
  {
    return src;
  }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.routineIs( o.onEach ) );
  _.assert( _.routineIs( o.onMake ) );

  result.push( o.onEach( o.onMake, undefined, 'no evaluator' ) );
  result.push( o.onEach( make, evaluator, 'evaluator' ) );
  result.push( o.onEach( make, [ evaluator, evaluator ], 'tandem of evaluators' ) );
  result.push( o.onEach( make, equalizer, 'equalizer' ) );

  return result;

  /* */

  function evaluator( e )
  {
    _.assert( e.length === 1 );
    return e[ 0 ];
  }

  /* */

  function equalizer( e1, e2 )
  {
    _.assert( e1.length === 1 );
    _.assert( e2.length === 1 );
    return e1[ 0 ] === e2[ 0 ];
  }

  /* */

  function make( long )
  {
    _.assert( _.longIs( long ) );
    let result = [];
    for( let l = 0 ; l < long.length ; l++ )
    result[ l ] = [ long[ l ] ];
    return o.onMake( result );
  }

}

diagnosticEachElementComparator.defaults =
{
  onMake : null,
  onEach : null,
}

//

function diagnosticStructureGenerate_pre( routine, args )
{
  _.assert( args.length === 0 || args.length === 1 );

  let o;
  if( args.length === 1 )
  o = args[ 0 ];
  else
  o = Object.create( null );

  o = _.routineOptions( diagnosticStructureGenerate, o );

  if( o.arrayLength === null )
  o.arrayLength = o.defaultLength;
  if( o.mapLength === null )
  o.mapLength = o.defaultLength;
  if( o.hashMapLength === null )
  o.hashMapLength = o.defaultLength;
  if( o.setLength === null )
  o.setLength = o.defaultLength;

  if( o.stringSize === null )
  o.stringSize = o.defaultSize;
  if( o.bufferSize === null )
  o.bufferSize = o.defaultSize;
  if( o.regexpSize === null )
  o.regexpSize = o.defaultSize;

  if( o.primitiveComplexity === null )
  o.primitiveComplexity = from( o.defaultComplexity );

  if( o.nullComplexity === null )
  o.nullComplexity = from( o.primitiveComplexity );
  if( o.undefinedComplexity === null )
  o.undefinedComplexity = from( o.primitiveComplexity );
  if( o.booleanComplexity === null )
  o.booleanComplexity = from( o.primitiveComplexity );
  if( o.stringComplexity === null )
  o.stringComplexity = from( o.primitiveComplexity );
  if( o.bigIntComplexity === null )
  o.bigIntComplexity = from( o.primitiveComplexity );

  if( o.numberComplexity === null )
  o.numberComplexity = from( o.primitiveComplexity );
  if( o.numberInfinityComplexity === null )
  o.numberInfinityComplexity = from( o.numberComplexity );
  if( o.numberNanComplexity === null )
  o.numberNanComplexity = from( o.numberComplexity );
  if( o.numberSignedZeroComplexity === null )
  o.numberSignedZeroComplexity = from( o.numberComplexity );

  if( o.objectComplexity === null )
  o.objectComplexity = from( o.defaultComplexity );
  if( o.dateComplexity === null )
  o.dateComplexity = from( o.objectComplexity );
  if( o.regexpComplexity === null )
  o.regexpComplexity = from( o.objectComplexity );

  if( o.bufferComplexity === null )
  o.bufferComplexity = from( o.objectComplexity );
  if( o.bufferNodeComplexity === null )
  o.bufferNodeComplexity = from( o.bufferComplexity );
  if( o.bufferRawComplexity === null )
  o.bufferRawComplexity = from( o.bufferComplexity );
  if( o.bufferBytesComplexity === null )
  o.bufferBytesComplexity = from( o.bufferComplexity );

  if( o.containerComplexity === null )
  o.containerComplexity = from( o.defaultComplexity );
  if( o.recursionComplexity === null )
  o.recursionComplexity = from( o.containerComplexity );
  if( o.arrayComplexity === null )
  o.arrayComplexity = from( o.containerComplexity );
  if( o.mapComplexity === null )
  o.mapComplexity = from( o.containerComplexity );
  if( o.setComplexity === null )
  o.setComplexity = from( o.containerComplexity );
  if( o.hashMapComplexity === null )
  o.hashMapComplexity = from( o.containerComplexity );

  _.assert( _.numberIs( o.depth ) );

  function from( complexity, min )
  {
    if( min === undefined )
    return complexity;

    if( complexity >= min )
    return complexity;

    return 0;
  }

  return o;
}

//

function diagnosticStructureGenerate_body( o )
{

  /**/

  o.structure = structureMake( 0 );
  o.size = _.entitySize( o.structure );

  return o;

  /*  */

  function structureMake( level )
  {
    let struct = Object.create( null );

    if( !( level <= o.depth ) )
    {
      return null;
    }

    if( o.nullComplexity >= 2 )
    {
      struct[ 'null' ] = null;
    }

    if( o.undefinedComplexity >= 3 )
    {
      struct[ 'undefined' ] = undefined;
    }

    if( o.booleanComplexity )
    {
      struct[ 'boolean.true' ] = true;
      struct[ 'boolean.false' ] = false;
    }

    if( o.stringComplexity )
    {
      if( o.random )
      struct[ 'string.defined' ] = _.strRandom( o.stringSize );
      else
      struct[ 'string.defined' ] = new RegExp( _.strDup( 'a', o.stringSize ) );
      struct[ 'string.empty' ] = '';
    }

    if( o.numberComplexity )
    {
      struct[ 'number.zero' ] = 0;
      struct[ 'number.small' ] = 13;
    }

    if( o.numberComplexity >= 2 )
    {
      struct[ 'number.big' ] = 1 << 30;
    }

    if( o.numberInfinityComplexity >= 2 )
    {
      struct[ 'number.infinity.positive' ] = +Infinity;
      struct[ 'number.infinity.negative' ] = -Infinity;
    }

    if( o.numberNanComplexity >= 2 )
    {
      struct[ 'number.nan' ] = NaN;
    }

    if( o.numberSignedZeroComplexity >= 3 )
    {
      struct[ 'number.signed.zero.negative' ] = -0;
      struct[ 'number.signed.zero.positive' ] = +0;
    }

    if( o.bigIntComplexity >= 3 )
    if( typeof BigInt !== 'undefined' )
    {
      struct[ 'bigInt.zero' ] = BigInt( 0 );
      struct[ 'bigInt.small' ] = BigInt( 1 );
      struct[ 'bigInt.big' ] = BigInt( 1 ) << BigInt( 100 );
    }

    if( o.regexpComplexity >= 2 )
    {
      if( o.random )
      struct[ 'regexp.defined' ] = new RegExp( _.strRandom( o.regexpSize ) );
      else
      struct[ 'regexp.defined' ] = new RegExp( _.strDup( 'a', o.regexpSize ) );
      struct[ 'regexp.simple1'] = /ab|cd/,
      struct[ 'regexp.simple2'] = /a[bc]d/,
      struct[ 'regexp.simple3'] = /ab{1, }bc/,
      struct[ 'regexp.simple4'] = /\.js$/,
      struct[ 'regexp.simple5'] = /.reg/
    }

    if( o.regexpComplexity >= 3 )
    {
      struct[ 'regexp.complex0' ] = /^(?:(?!ab|cd).)+$/gm,
      struct[ 'regexp.complex1' ] = /\/\*[\s\S]*?\*\/|\/\/.*/g,
      struct[ 'regexp.complex2' ] = /^[1-9]+[0-9]*$/gm,
      struct[ 'regexp.complex3' ] = /aBc/i,
      struct[ 'regexp.complex4' ] = /^\d+/gm,
      struct[ 'regexp.complex5' ] = /^a.*c$/g,
      struct[ 'regexp.complex6' ] = /[a-z]/m,
      struct[ 'regexp.complex7' ] = /^[A-Za-z0-9]$/
    }

    if( o.dateComplexity >= 3 )
    {
      struct[ 'date.now' ] = new Date();
      struct[ 'date.fixed' ] = new Date( 1987, 1, 4, 5, 13, 0 );
    }

    // let bufferSrc = _.longFillTimes( [], o.bufferSize || o.defaultSize, 0 );
    let bufferSrc = _.longRandom( [], [ 0, 1 ], [ 0, o.bufferSize ] );
    /* qqq : suspicious! */

    if( o.bufferNodeComplexity >= 4 )
    if( typeof BufferNode !== 'undefined' )
    struct[ 'buffer.node'] = BufferNode.from( bufferSrc );

    if( o.bufferRawComplexity >= 3 )
    struct[ 'buffer.raw'] = new U8x( bufferSrc ).buffer;

    if( o.bufferBytesComplexity >= 3 )
    struct[ 'buffer.bytes'] = new U8x( bufferSrc );

    if( o.arrayComplexity )
    struct[ 'array.simple' ] = _.longFill( [], 0, [ 0, o.arrayLength ] )

    if( o.arrayComplexity >= 3 )
    {
      struct[ 'array.complex' ] = [];
      for( let a = 0 ; a < o.arrayLength ; a++ )
      struct[ 'array.complex' ][ a ] = structureMake( level+1 );
    }

    /*  */

    if( o.setComplexity >= 3 )
    {
      struct[ 'set' ] = new Set;
      for( let m = 0 ; m < o.setLength ; m++ )
      struct[ 'set' ].add( structureMake( level+1 ) );
    }

    /*  */

    if( o.hashMapComplexity >= 4 )
    {
      struct[ 'hashmap' ] = new HashMap;
      for( let m = 0 ; m < o.hashMapLength ; m++ )
      struct[ 'hashmap' ].set( 'element' + m, structureMake( level+1 ) );
    }

    /*  */

    if( o.mapComplexity )
    {
      // let map = struct[ 'mapComplex' ] = { 0 : '1', 1 : { b : 2 }, 2 : [ 1, 2, 3 ] };
      // if( o.mapLength )
      // struct[ 'map.complex' ] = mapFor( map, [ 0, 3 ] );
      struct[ 'map' ] = Object.create( null );
      for( let m = 0 ; m < o.mapLength ; m++ )
      struct[ 'map' ][ 'element' + m ] = structureMake( level+1 );
    }

    // if( o.map || o.structure )
    // if( o.mapComplexity )
    // {
    //   // let map = struct[ 'map' ] = { 0 : string, 1 : 1, 2 : true  };
    //   // if( o.mapLength )
    //   debugger;
    //   let map = struct[ 'map' ] = { 0 : string, 1 : 1, true : true  };
    //   struct[ 'map.simple' ] = mapFor( map, [ 0, 1 << 25 ] );
    // }

    if( level < o.depth )
    {
      struct[ 'level' + ( level + 1 ) ] = structureMake( level+1 );
    }

    if( o.recursionComplexity >= 2 )
    {
      struct[ 'recursion.self' ] = struct;
    }

    if( o.recursionComplexity >= 3 && struct[ 'level' + ( level + 1 ) ] )
    {
      struct[ 'level' + ( level + 1 ) ][ 'recursion.super' ] = struct;
    }

    return struct;

    /*  */

    function mapFor( src, range )
    {
      let map = {};
      for( var i = 0; i < o.mapLength; i++ )
      {
        let k = _.intRandom( range );
        map[ i ] = src[ k ];
      }
      return map;
    }
  }

  /* */

  // function from( complexity, min )
  // {
  //   if( min === undefined )
  //   return complexity;

  //   if( complexity >= min )
  //   return complexity;

  //   return 0;
  // }

/*

  if( o.booleanComplexity || o.primitiveComplexity )
  currentLevel[ 'booleanComplexity' ] = true;

  if( o.numberComplexity || o.primitiveComplexity )
  currentLevel[ 'numberComplexity' ] = 0;

  if( o.numberSignedZeroComplexity || o.primitiveComplexity > 2 )
  {
    currentLevel[ '-0' ] = -0;
    currentLevel[ '+0' ] = +0;
  }

  if( o.string || o.primitiveComplexity )
  currentLevel[ 'string' ] = string;

  if( o.nullComplexity || o.primitiveComplexity > 1 )
  currentLevel[ 'null' ] = null;

  if( o.numberInfinityComplexity || o.primitiveComplexity > 1 )
  {
    currentLevel[ '+numberInfinityComplexity' ] = +Infinity;
    currentLevel[ '-numberInfinityComplexity' ] = -Infinity;
  }

  if( o.numberNanComplexity || o.primitiveComplexity > 1 )
  currentLevel[ 'numberNanComplexity' ] = NaN;

  if( o.undefinedComplexity || o.primitiveComplexity > 2 )
  currentLevel[ 'undefined' ] = undefined;

  if( o.dateComplexity || o.primitiveComplexity > 2 )
  currentLevel[ 'dateComplexity' ] = new Date();

  if( o.bigIntComplexity || o.primitiveComplexity > 2 )
  if( typeof BigInt !== 'undefined' )
  currentLevel[ 'bigInt' ] = BigInt( 1 );

*/

}

diagnosticStructureGenerate_body.defaults =
{

  structure : null,

  /*  */

  depth : 1,
  random : 1,
  stringSize : null,
  bufferSize : null,
  regexpSize : null,
  defaultSize : 50,

  arrayLength : null,
  mapLength : null,
  hashMapLength : null,
  setLength : null,
  defaultLength : 4,

  /* */

  defaultComplexity : 2,

  primitiveComplexity : null,
  nullComplexity : null,
  undefinedComplexity : null,
  booleanComplexity : null,
  stringComplexity : null,
  bigIntComplexity : null,
  numberComplexity : null,
  numberInfinityComplexity : null,
  numberNanComplexity : null,
  numberSignedZeroComplexity : null,

  objectComplexity : null,
  dateComplexity : null,
  regexpComplexity : null,
  bufferComplexity : null,
  bufferNodeComplexity : null,
  bufferRawComplexity : null,
  bufferBytesComplexity : null,

  containerComplexity : null,
  recursionComplexity : null,
  arrayComplexity : null,
  mapComplexity : null,
  setComplexity : null,
  hashMapComplexity : null,

}

//

/**
 * Routine diagnosticStructureGenerate generates structure with different data types in provided options map {-o-}. The final resulted structure almost defined by
 * property {-o.defaultComplexity-} of options map {-o-} and other separate options.
 * If routine calls without arguments, then routine returns new map with structure that generates from default parameters.
 *
 * @param { Map } o - The options map. Options map includes next options:
 *
 * @param { Number } o.defaultComplexity - The complexity of data types, options of which is not defined directly. Default value - 2.
 *
 * @param { Number } o.primitiveComplexity - The default complexity for primitives. If option is not defined, then it inherits {-o.defaultComplexity-}.
 * @param { Number } o.nullComplexity - Option for enabling generating of null. To generate null, it should be 2 or more.
 * @param { Number } o.undefinedComplexity - Option for enabling generating of undefined. To generate undefined, it should be 3 or more.
 * @param { Number } o.booleanComplexity - Option for enabling generating of boolean values. To generate true and false, it should be 1 or more.
 * @param { Number } o.stringComplexity - Option for enabling generating of string. To generate random string with {-o.stringSize-} length
 * and empty string, it should be 1 or more.
 * @param { Number } o.bigIntComplexity - Option for enabling generating of bigInt numbers. To generate bigInt zero, small and big value, it should be 3 or more.
 * @param { Number } o.numberComplexity - Option for enabling generating of numbers. To generate zero and small value, it should be 1. If option is 2 or more,
 * then routine generates big value.
 * @param { Number } o.numberInfinityComplexity - Option for enabling generating of Infinity values. To generate positive and negative Infinity,
 * it should be 2 or more.
 * @param { Number } o.numberNanComplexity - Option for enabling generating of NaN. To generate NaN, it should be 2 or more.
 * @param { Number } o.numberSignedZeroComplexity - Option for enabling generating of signed zero values. To generate positive and negative zero,
 * it should be 3 or more.
 *
 * @param { Number } o.objectComplexity - The default complexity for Date, RegExp and buffers. If option is not defined, then it inherits {-o.defaultComplexity-}.
 * @param { Number } o.dateComplexity - Option for enabling generating of Date instances. To generate Date instance with current date and with fixed date,
 * it should be 3 or more.
 * @param { Number } o.regexpComplexity - Option for enabling generating of regexps. To generate simple regexps, it should be 2. To generate complex
 * regexps it should be 3 or more.
 * @param { Number } o.bufferComplexity - The default complexity for buffers ( raw, typed, view, node ). If option is not defined,
 * then it inherits {-o.objectComplexity-}
 * @param { Number } o.bufferNodeComplexity - Option for enabling generating of BufferNode. To generate BufferNode, it should be 4 or more.
 * @param { Number } o.bufferRawComplexity - Option for enabling generating of BufferRaw. To generate BufferRaw it should be 3 or more.
 * @param { Number } o.bufferBytesComplexity - Option for enabling generating of typed U8x buffer. To generate BufferBytes, it should be 3 or more.

 * @param { Number } o.containerComplexity - The default complexity array, map, Set, HashMap and recursion. If option is not defined, then
 * it inherits {-o.defaultComplexity-}.
 * @param { Number } o.recursionComplexity - Option for enabling generating field with recursive link to current structure. To generate link,
 * it should be 2 or more.
 * @param { Number } o.arrayComplexity - Option for enabling generating of array. To generate flat array, it should be 2. If option set to 3 or more,
 * then routine generated array with nested arrays. Depth of nesting defines by option {-o.depth-}.
 * @param { Number } o.mapComplexity - Option for enabling generating of map. To generate map, it should be 1 or more.
 * @param { Number } o.setComplexity - Option for enabling generating of Set. To generate Set, it should be 3 or more.
 * @param { Number } o.hashMapComplexity - Option for enabling generating of HashMap. To generate HashMap, it should be 4 or more.
 *
 * @param { Number } o.depth - Defines maximal generated level of nesting for complex data structure. Default value - 1.
 * @param { Number } defaultSize - The default size of generated string, buffer, regexp. Default value - 50.
 * @param { Number } o.stringSize - The length of generated string.
 * @param { Number } o.bufferSize - The length of generated buffer ( raw, typed, view, node ).
 * @param { Number } o.regexpSize - The length of generated regexp.
 * @param { Number } o.defaultLength - The default length for generated array, map, HashMap, Set. Default value - 4.
 * @param { Number } o.arrayLength - The length of generated array.
 * @param { Number } o.mapLength - The length of generated map.
 * @param { Number } o.hashMapLength - The length of generated HashMap.
 * @param { Number } o.setLength - The length of generated Set.
 *
 * @example
 * _.diagnosticStructureGenerate()
 * //returns
 * // [Object: null prototype]
 * // {
 * //   structure: [Object: null prototype]
 * //   {
 * //     // generated structure
 * //   },
 * //   depth: 1,
 * //   stringSize: 50,
 * //   bufferSize: 50,
 * //   regexpSize: 50,
 * //   defaultSize: 50,
 * //   arrayLength: 4,
 * //   mapLength: 4,
 * //   hashMapLength: 4,
 * //   setLength: 4,
 * //   defaultLength: 4,
 * //   defaultComplexity: 2,
 * //   primitiveComplexity: 2,
 * //   nullComplexity: 2,
 * //   undefinedComplexity: 2,
 * //   booleanComplexity: 2,
 * //   ...
 * //   // other options
 * // }
 *
 * @returns { Map } - Returns map with diagnostic data types of defined complexity.
 * @function diagnosticStructureGenerate
 * @throws { Error } If arguments.length is more then one.
 * @throws { Error } If options map {-o-} is not mapLike.
 * @throws { Error } If options map {-o-} has unknown options.
 * @memberof wTools
 */

let diagnosticStructureGenerate = _.routineFromPreAndBody( diagnosticStructureGenerate_pre, diagnosticStructureGenerate_body );

// --
// checker
// --

function isInstanceOrClass( _constructor, _this )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  debugger;
  let result =
  (
    _this === _constructor ||
    _this instanceof _constructor ||
    Object.isPrototypeOf.call( _constructor,_this ) ||
    Object.isPrototypeOf.call( _constructor,_this.prototype )
  );
  return result;
}

//

function ownNoConstructor( ins )
{
  _.assert( _.objectLikeOrRoutine( ins ) );
  _.assert( arguments.length === 1 );
  let result = !_ObjectHasOwnProperty.call( ins,'constructor' );
  return result;
}

//

function sureInstanceOrClass( _constructor, _this )
{
  _.sure( arguments.length === 2, 'Expects exactly two arguments' );
  _.sure( _.isInstanceOrClass( _constructor, _this ) );
}

//

function sureOwnNoConstructor( ins )
{
  _.sure( _.objectLikeOrRoutine( ins ) );
  // let args = _.longSlice( arguments );
  let args = Array.prototype.slice.call( arguments );
  args[ 0 ] = _.ownNoConstructor( ins );
  _.sure.apply( _, args );
}

//

function assertInstanceOrClass( _constructor, _this )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.isInstanceOrClass( _constructor, _this ) );
}

//

function assertOwnNoConstructor( ins )
{
  _.assert( _.objectLikeOrRoutine( ins ) );
  // let args = _.longSlice( arguments );
  let args = Array.prototype.slice.call( arguments );
  args[ 0 ] = _.ownNoConstructor( ins );

  if( args.length === 1 )
  args.push( () => 'Entity should not own constructor, but own ' + _.toStrShort( ins ) );

  _.assert.apply( _, args );
}

// --
// errrors
// --

let ErrorAbort = _.error_functor( 'ErrorAbort' );

// --
// declare
// --

/* zzz : move into independent module or namespace */

let error =
{
  ErrorAbort,
}

let ExtendTools =
{

  // diagnosticCode,
  diagnosticBeep,

  diagnosticWatchFields, /* experimental */
  diagnosticProxyFields, /* experimental */
  diagnosticEachLongType,
  diagnosticEachElementComparator,

  diagnosticStructureGenerate,

  // checker

  isInstanceOrClass,
  ownNoConstructor,

  // sure

  sureInstanceOrClass,
  sureOwnNoConstructor,

  // assert

  assertInstanceOrClass,
  assertOwnNoConstructor,

}

Object.assign( _.error, error );
Object.assign( _, ExtendTools );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _;

})();
