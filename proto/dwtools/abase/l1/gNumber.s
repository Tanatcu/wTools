( function _gNumber_s_() {

'use strict';

let _global = _global_;
let _ = _global_.wTools;
let Self = _global_.wTools;

let _ArrayIndexOf = Array.prototype.indexOf;
let _ArrayLastIndexOf = Array.prototype.lastIndexOf;
let _ArraySlice = Array.prototype.slice;
let _ArraySplice = Array.prototype.splice;
let _FunctionBind = Function.prototype.bind;
let _ObjectToString = Object.prototype.toString;
let _ObjectHasOwnProperty = Object.hasOwnProperty;
let _ObjectPropertyIsEumerable = Object.propertyIsEnumerable;
let _ceil = Math.ceil;
let _floor = Math.floor;

// --
// number
// --

function numbersTotal( numbers )
{
  let result = 0;
  _.assert( _.longIs( numbers ) );
  _.assert( arguments.length === 1, 'Expects single argument' );
  for( let n = 0 ; n < numbers.length ; n++ )
  {
    let number = numbers[ n ];
    _.assert( _.numberIs( number ) )
    result += number;
  }
  return result;
}

//

function numberFrom( src )
{
  _.assert( arguments.length === 1 );
  if( _.strIs( src ) )
  {
    return parseFloat( src );
  }
  return Number( src );
}

//

function numbersFrom( src )
{
  if( _.strIs( src ) )
  return _.numberFrom( src );

  let result;

  if( _.longIs( src ) )
  {
    result = [];
    for( let s = 0 ; s < src.length ; s++ )
    result[ s ] = _.numberFrom( src[ s ] );
  }
  else if( _.objectIs( src ) )
  {
    result = Object.create( null );
    for( let s in src )
    result[ s ] = _.numberFrom( src[ s ] );
  }

  return result;
}

//

function numberFromStr( src )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( src ) )
  let result = parseFloat( src );
  return result;
}

//

function numbersSlice( src,f,l )
{
  if( _.numberIs( src ) )
  return src;
  return _.longSlice( src,f,l );
}

//

function numberRandomInRange( range )
{

  _.assert( arguments.length === 1 && _.arrayIs( range ),'numberRandomInRange :','Expects range( array ) as argument' );
  _.assert( range.length === 2 );

  return _random()*( range[ 1 ] - range[ 0 ] ) + range[ 0 ];

}

//

function numberRandomInt( range )
{

  if( _.numberIs( range ) )
  range = range >= 0 ? [ 0,range ] : [ range,0 ];
  else if( _.arrayIs( range ) )
  range = range;
  else _.assert( 0,'numberRandomInt','Expects range' );

  _.assert( _.arrayIs( range ) || _.numberIs( range ) );
  _.assert( range.length === 2 );

  let result = Math.floor( range[ 0 ] + Math.random()*( range[ 1 ] - range[ 0 ] ) );

  return result;
}

//

function numberRandomIntBut( range )
{
  let result;
  let attempts = 50;

  if( _.numberIs( range ) )
  range = [ 0,range ];
  else if( _.arrayIs( range ) )
  range = range;
  else throw _.err( 'numberRandomInt','unexpected argument' );

  for( let attempt = 0 ; attempt < attempts ; attempt++ )
  {
    // if( attempt === attempts-2 )
    // debugger;
    // if( attempt === attempts-1 )
    // debugger;

    /*result = _.numberRandomInt( range ); */
    let result = Math.floor( range[ 0 ] + Math.random()*( range[ 1 ] - range[ 0 ] ) );

    let bad = false;
    for( let a = 1 ; a < arguments.length ; a++ )
    if( _.routineIs( arguments[ a ] ) )
    {
      if( !arguments[ a ]( result ) )
      bad = true;
    }
    else
    {
      if( result === arguments[ a ] )
      bad = true;
    }

    if( bad )
    continue;
    return result;
  }

  result = NaN;
  return result;
}

//

function numbersMake( src,length )
{
  let result;

  if( _.vectorAdapterIs( src ) )
  src = _.vector.slice( src );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.numberIs( src ) || _.arrayLike( src ) );

  if( _.arrayLike( src ) )
  {
    _.assert( src.length === length );
    result = _.array.makeArrayOfLength( length );
    for( let i = 0 ; i < length ; i++ )
    result[ i ] = src[ i ];
  }
  else
  {
    result = _.array.makeArrayOfLength( length );
    for( let i = 0 ; i < length ; i++ )
    result[ i ] = src;
  }

  return result;
}

//

function numbersFromNumber( src,length )
{

  if( _.vectorAdapterIs( src ) )
  src = _.vector.slice( src );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.numberIs( src ) || _.arrayLike( src ) );

  if( _.arrayLike( src ) )
  {
    _.assert( src.length === length );
    return src;
  }

  let result = _.array.makeArrayOfLength( length );
  for( let i = 0 ; i < length ; i++ )
  result[ i ] = src;

  return result;
}

//

function numbersFromInt( dst,length )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.numberIsInt( dst ) || _.arrayIs( dst ),'Expects array of number as argument' );
  _.assert( length >= 0 );

  if( _.numberIs( dst ) )
  {
    debugger;
    // dst = _.longFillTimes( [], length , dst );
    dst = _.longFill( [], dst, length );
  }
  else
  {
    for( let i = 0 ; i < dst.length ; i++ )
    _.assert( _.numberIsInt( dst[ i ] ),'Expects integer, but got',dst[ i ] );
    _.assert( dst.length === length,'Expects array of length',length,'but got',dst );
  }

  return dst;
}

//

function numbersMake_functor( length )
{
  let _ = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.numberIs( length ) );

  function numbersMake( src )
  {
    return _.numbersMake( src,length );
  }

  return numbersMake;
}

//

function numbersFrom_functor( length )
{
  let _ = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.numberIs( length ) );

  function numbersFromNumber( src )
  {
    return _.numbersFromNumber( src,length );
  }

  return numbersFrom;
}

// --
// fields
// --

let Fields =
{
}

// --
// routines
// --

let Routines =
{

  numbersTotal,

  numberFrom,
  numbersFrom, /* qqq : add test coverage */
  numberFromStr,

  numbersSlice,

  numberRandomInRange,
  numberRandomInt,
  numberRandomIntBut, /* dubious */

  numbersMake,
  numbersFromNumber,
  numbersFromInt,

  numbersMake_functor,
  numbersFrom_functor,

}

//

Object.assign( Self, Routines );
Object.assign( Self, Fields );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
