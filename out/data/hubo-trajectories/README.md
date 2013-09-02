hubo-trajectories
=================

A collection of trajectory files for use with hubo-read-trajectory, starting with everyone's favorite Rainbow, Inc demo gestures. They are pretty and the columns are perfectly aligned, so you can easily read and debug them in a text editor. (E.g. all the numbers are signed, so if you have to flip the signs of a column, you can do that with some find & replace magic and still have all your columns beautifully aligned.)

If you want to implement code to read them, know that:

* The first line is a header of field names.
* The delimeter is 1 or MORE spaces. Not tabs. Never tabs. Tabs are evil.
* Each column is exactly 12 characters wide. (1 for sign, 10 for number, 1 mandatory space)
* Columns are left aligned and padded with spaces.

`tools` folder
--------------

Let's say you don't want to edit your trajectory files by hand. Honestly, I get sick of that too sometimes. When that happens, I load them into MATLAB:

```MATLAB
[ data, joints ] = loadTraj( filename );
```

* `data` contains the numbers. 
* `joints` is a cell array containing the header fields (in this case, the joint names).

Let's say you've fixed that gnarly bug in your trajectory, and you want to write it out to a file. Easy enough:

```MATLAB
saveTraj( filename, data, joints );
```
