/*
 * Dict Object for JavaScript (https://gist.github.com/wmhilton/5859079)
 * Author: William Hilton (wmhilton@gmail.com)
 * License: http://opensource.org/licenses/MIT
 *
 * Say you want something like a Python "dictionary" or a Java "map" where you
 * are storing (String key, Object value) pairs. It's tempting to do it using 
 * object properties in JavaScript, since 
 *   obj['key'] = value
 * works so conveniently. However, say you want to be able to have some properties
 * on your dictionary like compute its size, or have methods like sort(), or have
 * assignable attributes like .name. Since you are already using the object's 
 * properties as your (key,value) map adding these features is a little tricky. 
 * Here's an example of how to accomplish such a thing.
 */
var Dict = function() {};
Dict.prototype = {
    // A read-only property to compute the size of the dictionary.
    get count() {
        return Object.keys(this).length;
    },
    // Here is a custom property that can be set and get.
    get expectedCount() {
        return _expCnt;
    },
    set expectedCount(val) {
        _expCnt = val;
    },
    // This allows us to iterate easily over the members using .forEach()
    asArray: function() {
        var arr = [];
        for (var prop in this) {
            if (this.hasOwnProperty(prop)) {
                arr.push(this[prop]);
            }
        }
        return arr;
    }
};
// By defining this property, we can store the value "tucked away" inside the prototype.
Dict.prototype._expCnt = 0;

/*
foo = new Dict()
// Dict {}
// Notice how in the debugger, foo appears to have no properties.
// Both the count and expectedCount are not properties of foo, but of foo's prototype.
foo.count
// 0
foo['bar'] = 'jawn';
foo.count
// 1
foo['sam'] = 1;
foo.bob = 1;
// Just demonstrating both ways of setting a Javascript object property.
foo.count
// 3
foo.expectedCount
// 0
foo.expectedCount = 3;
// Note that .count doesn't increase
foo.count
// 3
foo.expectedCount
// 3
// We have successfully stored a piece of data in foo, without 
// adding a property to the foo object and messing up our (key,value) map.
*/