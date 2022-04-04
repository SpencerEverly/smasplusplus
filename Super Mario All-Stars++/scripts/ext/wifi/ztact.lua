

-- public domain 20080617 lua@ztact.com


pcall (require, 'lfs')      -- lfs may not be installed/necessary.
pcall (require, 'pzp')
pcall (require, 'pozix')    -- pozix may not be installed/necessary.


local  assert		=  assert
local  byte		=  string.byte
local  char		=  string.char
local  concat		=  table.concat
local  coroutine	=  coroutine
local  dofile		=  dofile
local  error		=  error
local  format		=  string.format
local  getfenv		=  getfenv
local  getlocal		=  debug.getlocal
local  io		=  io
local  insert		=  table.insert
local  ipairs		=  ipairs
local  lfs		=  lfs
local  math		=  math
local  next		=  next
local  os		=  os
local  pairs		=  pairs
local  pcall		=  pcall
local  pozix		=  pozix
local  print		=  print
local  pzp		=  pzp
local  remove		=  table.remove
local  require		=  require
local  select		=  select
local  setfenv		=  setfenv
local  setmetatable	=  setmetatable
local  stat		=  pozix.stat
local  string		=  string
local  table		=  table
local  tonumber		=  tonumber
local  tostring		=  tostring
local  type		=  type
local  unpack		=  unpack
local  xpcall		=  xpcall


module ((...) or 'ztact')    ------------------------------------- module ztact
local ztact = getfenv ()


-- dir -------------------------------------------------------------------- dir


function dir (path)    -- - - - - - - - - - - - - - - - - - - - - - - - - - dir
  local it = lfs.dir (path)
  return function ()
    repeat
      local dir = it ()
      if dir ~= '.' and dir ~= '..' then  return dir  end
    until not dir
    end  end


function is_file (path)    -- - - - - - - - - - - - - - - - - -  is_file (path)
  local mode = lfs.attributes (path, 'mode')
  return mode == 'file' and path
  end


-- network byte ordering -------------------------------- network byte ordering


function htons (word)    -- - - - - - - - - - - - - - - - - - - - - - - - htons
  return (word-word%0x100)/0x100, word%0x100
  end


-- pcall2 -------------------------------------------------------------- pcall2


getfenv ().pcall = pcall    -- store the original pcall as ztact.pcall


local argc, argv, errorhandler, pcall2_f


local function _pcall2 ()    -- - - - - - - - - - - - - - - - - - - - - _pcall2
  local tmpv = argv
  argv = nil
  return pcall2_f (unpack (tmpv, 1, argc))
  end


function seterrorhandler (func)    -- - - - - - - - - - - - - - seterrorhandler
  errorhandler = func
  end


function pcall2 (f, ...)    -- - - - - - - - - - - - - - - - - - - - - - pcall2

  pcall2_f = f
  argc = select ('#', ...)
  argv = { ... }

  if not errorhandler then
    local debug = require ('debug')
    errorhandler = debug.traceback
    end

  return xpcall (_pcall2, errorhandler)
  end


function append (t, ...)    -- - - - - - - - - - - - - - - - - - - - - - append
  local len = #t
  local argc = select ('#', ...)
  if argc == 0 then
    local append = append
    local function ap (...)  append (t, ...)  end
    return t, ap
    end
  for i=1,argc do  t[len+i] = select (i, ...)  end
  end


function print_r (d, indent)    -- - - - - - - - - - - - - - - - - - -  print_r
  local rep = string.rep ('  ', indent or 0)
  if type (d) == 'table' then
    for k,v in pairs (d) do
      if type (v) == 'table' then
        io.write (rep, k, '\n')
        print_r (v, (indent or 0) + 1)
      else  io.write (rep, k, ' = ', tostring (v), '\n')  end
      end
  else  io.write (d, '\n')  end
  end


function tohex (s)    -- - - - - - - - - - - - - - - - - - - - - - - - -  tohex
  return string.format (string.rep ('%02x ', #s), string.byte (s, 1, #s))
  end


function tostring_r (d, indent, tab0)    -- - - - - - - - - - - - -  tostring_r

  tab1 = tab0 or {}
  local rep = string.rep ('  ', indent or 0)
  if type (d) == 'table' then
    for k,v in pairs (d) do
      if type (v) == 'table' then
        append (tab1, rep, k, '\n')
        tostring_r (v, (indent or 0) + 1, tab1)
      else  append (tab1, rep, k, ' = ', tostring (v), '\n')  end
      end
  else  append (tab1, d, '\n')  end

  if not tab0 then  return table.concat (tab1)  end
  end




do    -- email ---------------------------------------------------------- email


local email = {}


function email.address (s)    ----------------------------------------- address
  return string.match (s, '((%w[%w-._]*)@([%w-._]*%w))')
  end


function email.header_get (self, which)    ------------------- email.header_get
  if type (which) == 'string' then
    return self.headers[self.headers[which]]  end
  error ('header_get: type (which): '..type (which))
  end


email.header = email.header_get


function email.header_set (self, which, value)    ------------ email.header_set
  local i = assert (self.headers[which])
  self.headers[i] = value
  end


function email.headers_parse (self, input)    ------------- email.headers_parse

  local buf = {}
  for line in input:lines () do
    if #line == 0 then  break  end
    if string.match (line, '^%S') then
      if #buf > 0 then  append (self.headers, table.concat (buf, '\n'))  end
      buf = {}
      end
    append (buf, line)
    end
  if #buf > 0 then  append (self.headers, table.concat (buf, '\n'))  end

  for i,header in ipairs (self.headers) do
    local m = string.match (header, '[%w-]+')
    if not m then  break  end    -- malformed email message?
    self.headers[string.lower (m)] = i
    end

  -- print ('mail_from', self.headers.from)
  -- self.mail_from = self:header_get ('from')
  -- self:headers_print ()

  return #self.headers > 0
  end


function email.headers_print (self)    -------------------- email.headers_print
  for k,h in pairs (self.headers) do  print (k, h)  print ('---')  end  end


function email.headers_write (self, out)    --------------- email.headers_write
  for h in ivalues (self.headers) do  out:write (h..'\n')  end
  end


local email_mt = { __index = email, __metatable = false }


function ztact.email (input)    ----------------------------------------- email
  local email = setmetatable ({ headers = {} }, email_mt)
  if input then  email:headers_parse (input)  end
  return email
  end


end    -- email --------------------------------------------------------- email




-- queue manipulation -------------------------------------- queue manipulation


-- Possible queue states.  1 (i.e. queue.p[1]) is head of queue.
--
-- 1..2
-- 3..4  1..2
-- 3..4  1..2  5..6
-- 1..2        5..6
--             1..2


local function print_queue (queue, ...)    -- - - - - - - - - - - - print_queue
  for i=1,10 do  io.write ((queue[i]   or '.')..' ')  end
  io.write ('\t')
  for i=1,6  do  io.write ((queue.p[i] or '.')..' ')  end
  print (...)
  end


function dequeue (queue)    -- - - - - - - - - - - - - - - - - - - - -  dequeue

  local p = queue.p
  if not p and queue[1] then  queue.p = { 1, #queue }  p = queue.p  end

  if not p[1] then  return nil  end

  local element = queue[p[1]]
  queue[p[1]] = nil

  if p[1] < p[2] then  p[1] = p[1] + 1

  elseif p[4] then  p[1], p[2], p[3], p[4]  =  p[3], p[4], nil, nil

  elseif p[5] then  p[1], p[2], p[5], p[6]  =  p[5], p[6], nil, nil

  else  p[1], p[2]  =  nil, nil  end

  -- print_queue (queue, '  de '..element)
  return element
  end


function enqueue (queue, element)    -- - - - - - - - - - - - - - - - - enqueue

  local p = queue.p
  if not p then  queue.p = {}  p = queue.p  end

  if p[5] then    -- p3..p4 p1..p2 p5..p6
    p[6] = p[6]+1
    queue[p[6]] = element

  elseif p[3] then    -- p3..p4 p1..p2

    if p[4]+1 < p[1] then
      p[4] = p[4] + 1
      queue[p[4]] = element

    else
      p[5] = p[2]+1
      p[6], queue[p[5]] = p[5], element
      end

  elseif p[1] then    -- p1..p2
    if p[1] == 1 then
      p[2] = p[2] + 1
      queue[p[2]] = element

    else
        p[3], p[4], queue[1] = 1, 1, element
        end

  else    -- empty queue
    p[1], p[2], queue[1] = 1, 1, element
    end

  -- print_queue (queue, '     '..element)
  end


local function test_queue ()
  t = {}
  enqueue (t, 1)
  enqueue (t, 2)
  enqueue (t, 3)
  enqueue (t, 4)
  enqueue (t, 5)
  dequeue (t)
  dequeue (t)
  enqueue (t, 6)
  enqueue (t, 7)
  enqueue (t, 8)
  enqueue (t, 9)
  dequeue (t)
  dequeue (t)
  dequeue (t)
  dequeue (t)
  enqueue (t, 'a')
  dequeue (t)
  enqueue (t, 'b')
  enqueue (t, 'c')
  dequeue (t)
  dequeue (t)
  dequeue (t)
  dequeue (t)
  dequeue (t)
  enqueue (t, 'd')
  dequeue (t)
  dequeue (t)
  dequeue (t)
  end


-- test_queue ()


function queue_len (queue)
  end


function queue_peek (queue)
  end


-- queues -------------------------------------------------------------- queues


local queue_mt = { __index = {} }


queue_mt.__index.enqueue = enqueue
queue_mt.__index.dequeue = dequeue


function queue_mt.__index.len (q)    -------------------------------- queue.len
  local q1, q2, q3, q4, q5, q6 = unpack (q.p)
  -- print ('len', unpack (q.p, 1, 6))
  local len = 0
  if q1 then  len = len + q2 - q1 + 1  end
  if q3 then  len = len + q4 - q3 + 1  end
  if q5 then  len = len + q6 - q5 + 1  end
  return len
  end


function queue_mt.__index.peek (q)    ------------------------------ queue.peek
  return q.p[1] and q[q.p[1]]  end


function queue_create ()    -------------------------------------- queue_create
  return setmetatable ( { p = {} }, queue_mt )
  end


-- tree manipulation ---------------------------------------- tree manipulation


function set (parent, ...)    --- - - - - - - - - - - - - - - - - - - - - - set

  -- print ('set', ...)

  local len = select ('#', ...)
  local key, value = select (len-1, ...)
  local cutpoint, cutkey

  for i=1,len-2 do

    local key = select (i, ...)
    local child = parent[key]

    if value == nil then
      if child == nil then  return
      elseif next (child, next (child)) then  cutpoint = nil  cutkey = nil
      elseif cutpoint == nil then  cutpoint = parent  cutkey = key  end

    elseif child == nil then  child = {}  parent[key] = child  end

    parent = child
    end

  if value == nil and cutpoint then  cutpoint[cutkey] = nil
  else  parent[key] = value  return value  end
  end


function get (parent, ...)    --- - - - - - - - - - - - - - - - - - - - - - get
  local len = select ('#', ...)
  for i=1,len do
    parent = parent[select (i, ...)]
    if parent == nil then  break  end
    end
  return parent
  end


function tree_descend (tree, depth)    -------------------------------- descend
  for i=1,depth do  tree = select (2, next (tree))  end
  return tree
  end


function tree_size (tree, depth)    --------------------------------- tree_size
  depth = depth or 1
  local size = 0
  for k,v in pairs (tree) do
    if depth <= 1 then  size = size + 1
    else  size = size + tree_size (v, depth - 1)  end
    end
  return size
  end


function tree_walks (tree)    -------------------------------------- tree_walks

  local stack = {}

  local function tree_walker (tree)
    for k,v in pairs (tree) do
      if type (v) == 'table' then
        insert (stack, k)
        tree_walker (v, stack)
        remove (stack)
      else
        insert (stack, k)
        insert (stack, v)
        coroutine.yield (unpack (stack))
        remove (stack)
        remove (stack)
        end  end  end

  return coroutine.wrap (tree_walker), tree
  end




do    -- tsvdb ---------------------------------------------------------- tsvdb


local tsvdb = {}


function tsvdb.flush ()    ---------------------------------------- tsvdb.flush
  -- to: implement persistent insert and flush
  end


function tsvdb.insert (self, row)    ----------------------------- tsvdb.insert

  local f
  if pozix.stat (self.path, 'exists') then
    f = io.open (self.path, 'a+')
    local columns = pzp.explode ('\t', f:read ())
    if #columns ~= #self.columns then  error 'tsvdb column mismatch'  end
    for i = 1,#columns do
      if columns[i] ~= self.columns[i] then  error 'tsvdb column mismatch'  end
      end
  else
    f = io.open (self.path, 'w')
    f:write (concat (self.columns, '\t')..'\n')
    end

  local t = {}
  for i,name in pairs (self.columns) do
    t[i] = row[name] or row[i] or ''  end

  local encoded = {}
  for i,v in ipairs (t) do  encoded[i] = tsv_encode (v)  end
  f:write (concat (encoded, '\t')..'\n')
  f:close ()
  end


function tsvdb.select (self, arg1, arg2, o)    ------------------- tsvdb.select

  --  arg1:  columns or          filter
  --  arg2:  where   or index or filter
  --  o:     options
  --
  --  columns is a table or string
  --  filter is a function (row, columns, result) returning boolean
  --    (row is complete, columns contains only the selected columns)
  --
  --  options:
  --    .array   result will be array (???)
  --    .filter  filter function (same as above)
  --    .group   column name or number to group by
  --    .index   results will be table keyed by column .index
  --
  --  note: I think you can use .array and .index together and result
  --  will be doubly keyed!

          -- parse args
  local columns, where
  o = type (o) == 'string' and { index = o } or optionize (o)
  local t1, t2 = type (arg1), type (arg2)
          -- parse arg1
  if t1 == 'function' then  o.filter = arg1
  else if t1 == 'nil' or t1 == 'string' or t1 == 'table' then  columns = arg1
  else  error ('tsv_select: arg #1 has invalid type: '..t1)
    end  end
          -- parse arg2
  if t2 == 'function' then  o.filter = arg2
  else if t2 == 'string' then  o.index = arg2
  else if t2 == 'nil' or t2 == 'table' then  where = arg2
  else  error ('tsv_select: arg #2 has invalid type: '..t2)
    end  end  end

  local f = io.open (self.path)
  if not f then  return {}  end
  local column_names = pzp.explode ('\t', f:read () or '')
  local flip = pzp.array_flip (column_names)

  columns = columns or '*'
  local expand = type (columns) == 'table'

  local result = {}
  for line in f:lines () do

            -- raw contains all the columns
    local raw = pzp.explode ('\t', line)
    for i,v in ipairs (raw) do  raw[i] = tsv_decode (v)  end
    for i,name in ipairs (column_names) do  raw[name] = raw[i]  end

            -- row contains only the selected columns
    local row = expand and {}
    if columns == '*' then  row = raw
    else if expand then
      for i,name in ipairs (columns) do
        local value = raw[flip[name]]
        row[name] = value
        append (row, value)
        end
    else  row = raw[flip[columns]]  end  end

    local where_test = true
    if where then
      for k,v in pairs (where) do
        if row[k] ~= v then  where_test = false  break  end
        end  end

            -- as needed: filter, index, and append
    if where_test and ( not o.filter or o.filter (raw, row, result) ) then
      if o.index then  result[raw[o.index]] = row  end
      if o.group then
        local k = raw[o.group]
	print (o.group, raw, k)
        result[k] = result[k] or {}
        append (result[k], row)
        end
      if o.array or not o.index and not o.group then  append (result, row)  end
      end  end

  f:close ()
  return result
  end


local tsvdb_mt = { __index = tsvdb, __metatable = false }


function ztact.tsvdb (path, columns)    --------------------------------- tsvdb
  local db = { path = path, columns = columns }
  setmetatable (db, tsvdb_mt)
  return db
  end


end    -- tsvdb --------------------------------------------------------- tsvdb




-- misc ------------------------------------------------------------------ misc


function array ()    ---------------------------------------------------- array
  return setmetatable ({}, { __index = { a = table.insert } })
  end


function expand (t, ...)    -------------------------------------------- expand

  local expanded = {}

  local function replace (k)
    if expanded[k] then  return expanded[k]  end
    if expanded[k] == false then  error (k..': infinite loop')  end
    expanded[k] = false
    local v = string.gsub (t[k], '$([%w_]+)', replace)
    expanded[k] = v
    return v
    end

  for k,v in pairs (t) do
    if type (v) == 'string' then
      replace (k)  end  end

  for k,v in pairs (expanded) do  t[k] = v  end
end


function find (root, ...)    --------------------------------------------- find

  -- find (root, ...)
  -- find ( { root, rel }, ... )

  -- note: op (path, rel, depth)
  -- note: in Bistro: op (path, rel, child, depth)

  local operators = {...}

  local dirs
  if type (root) == 'string' then    -- process root
    for op in values (operators) do
      if op (root, '', 1) == false then  return  end  end
    if not pozix.stat (root, 'is_dir') then  return  end
    dirs = { '', 2 }

  else if type (root) == 'table' then
    local rel
    root, rel = unpack (root)
    dirs = { rel..'/', 2 }

  else
    error ('find arg #1 expected string or table')
    end  end

          -- process root's children
  while next (dirs) do
    local depth, parent = table.remove (dirs), table.remove (dirs)
    for child in pozix.opendir (root..'/'..parent) do
      local path = root..'/'..parent..child
      local rel  = parent..child
      local recur = true
      for op in ivalues (operators) do
        if op (path, rel, depth) == false then
          recur = false  break  end  end
      if recur and pozix.stat (path, 'is_dir') then
        append (dirs, rel..'/', depth + 1)
        end  end  end  end


function flatten (...)    --------------------------------------------- flatten
  local t0 = {}
  local function flatten_ (t1)
    for i,v in ipairs (t1) do
      -- print (type (v), v)
      if type (v) == 'table' then  flatten_ (v)  else  insert (t0, v)  end
      end  end
  flatten_ {...}
  return t0
  end


function ivalues (t)    ----------------------------------------------- ivalues
  local i = 0
  return function ()  if t[i+1] then  i = i + 1  return t[i]  end  end
  end


function last (t)    ----------------------------------------------------- last
  return t[#t]  end


function len (t)    ------------------------------------------------------- len
  local len = 0
  for k in pairs (t) do  len = len + 1  end
  return len
  end


function lson_encode (mixed, f, indent, indents)    --------------- lson_encode

  local capture
  if not f then
    capture = {}
    f = function (s)  append (capture, s)  end
    end

  indent = indent or 0
  indents = indents or {}
  indents[indent] = indents[indent] or string.rep (' ', 2*indent)

  local type = type (mixed)

  if type == 'number' then f (mixed)

  else if type == 'string' then f (string.format ('%q', mixed))

  else if type == 'table' then
    f ('{')

    local keys = pzp.array_keys (mixed)
    table.sort (keys)
    for k in values (keys) do
      f ('\n')
      f (indents[indent])
      f ('[')  f (lson_encode (k))  f ('] = ')
      lson_encode (mixed[k], f, indent+1, indents)
      f (',')
      end
    f (' }')
    end  end  end

  if capture then  return table.concat (capture)  end
  end


function lson_write (o, path)    ----------------------------------- lson_write
  local f, tmp_path = pozix.mkstemp (path..'-XXXXXX')
  local function f_write (s)  f:write (s)  end
  f_write ('return ')
  lson_encode (o, f_write)
  f:close ()
  pozix.rename (tmp_path, path)
  end


function match_all (s, pattern)    ---------------------------------- match_all
  local t = {}
  for frag in string.gmatch (s, pattern) do  insert (t, frag)  end
  return t
  end


function maildirmake (dir, mode)    ------------------------------- maildirmake

  mode = mode or '0700'

  if not pozix.stat (dir, 'is_dir') then
    print ('here1', dir)
    print (pozix.lstat (dir, 'is_link'))
    if pozix.lstat (dir, 'is_link') then
      print 'here2'
      local link = pozix.readlink (dir)
      if string.find ('^/', link) then  mkdir (link, mode, true)
      else  pozix.mkdir (pozix.dirname (dir)..'/'..link, mode, true)  end
    else  pozix.mkdir (dir, mode, true)  end
    end

  for i,subdir in pairs {'cur', 'new', 'tmp'} do
    local dir = rtrim (dir, '/')..'/'..subdir
    if not pozix.stat (dir, 'is_dir') then  pozix.mkdir (dir, mode)  end
    end  end


function octal (mixed)    ----------------------------------------------- octal
  return tonumber (s, 8)
  end


function oo (mixed, G)    -------------------------------------------------- oo

  local mt = {}

  function mt.__index (t, k)
    -- print ('oo.__index', t, k)
    local name,other = getlocal (2, 1)
    if name == 'self' and type (other) == 'table' then
      local v = other[k]
      if v ~= nil then  return v  end
      end
    return G and G[k]
    end

  function mt.__newindex (t, k, v)
    local name,other = getlocal (2, 1)
    if name == 'self' and type (other) == 'table' and other[k] ~= nil then
      other[k] = v  return  end
    error ('no such field: '..tostring (k))
    end

  local env = setmetatable ({}, mt)

  if type (mixed) == 'table' then
    for k,v in pairs (mixed) do
      -- unfortunately I cannot probe at compile time
      if type (v) == 'function' then  setfenv (v, env)  end  end

  else  error ('ztact.oo: invalid type')  end

  end


do    -- open_unique ---------------------------------------------- open_unique


local nonce_ = 0
local function nonce ()  nonce_ = nonce_ + 1  return nonce_  end


function open_unique (dir, proxy)    ------------------------------ open_unique

  local file, unique
  local cwd, pid = pozix.getcwd (), pozix.getpid ()

  local hostname = proxy and proxy.hostname or pozix.gethostname
  local nonce = proxy and proxy.nonce or nonce

  pozix.chdir (dir)

  for i=0,9 do

    unique =
      os.time ()..
      '.'..
      'p'..string.format ('%06d', pid)..
      'q'..string.format ('%06d', nonce ())..
      'r'..string.format ('%09d', math.random (0, 999999999))..
      '.'..
      hostname ()

    if not stat (unique, 'mtime') then
      file = pozix.open (unique, 'wronly', 'create', 'excl')
      break
      end end

  pozix.chdir (cwd)
  return file, dir..'/'..unique
  end


end    -- open_unique --------------------------------------------- open_unique


function optionize (o)    ------------------------------------------- optionize
  if o == nil then  return {}  end
  if type (o) == string then  return { [o] = true }  end
  local new = {}
  for k,v in pairs (o) do  new[k] = v  end
  for i,v in ipairs (o) do  new[v] = new[v] or true  end
  return new
  end


function pack (...)    --------------------------------------------------- pack
  return { len = select ('#', ...), ... }  end


function pcall_dofile (path)    ---------------------------------- pcall_dofile
  local rv, o = pcall (dofile, path)
  return rv and o or nil
  end


function printf (format_, ...)    -------------------------------------- printf
  io.write (format (format_, ...))  end


function rtrim (s, charlist)    ----------------------------------------- rtrim
  return string.match (s, '^(.-)['..charlist..']*$')
  end


function split (s, pattern, limit)    ----------------------------------- split
  local i, t = 1, {}
  while true do
    local j, k = string.find (s, pattern, i)
    if j then
      insert (t, string.sub (s, i, j-1))
      i = k+1
    else
      insert (t, string.sub (s, i))
      break
      end  end
  return t
  end


function suffix (s)    ------------------------------------------------- suffix
  return string.match (s, '%.[^.]+$')  end


function timestamp (time)    ---------------------------------------- timestamp
  return os.date ('%Y%m%d.%H%M%S', time)
  end


function tsv_insert (path, t)    ----------------------------------- tsv_insert
  local f = assert (io.open (path, 'a+'))
  local column_names = pzp.explode ('\t', f:read ())
  for i,name in pairs (column_names) do
    if t.name then  t[i] = t.name  end  end
  f:write (table.concat (t, '\t')..'\n')
  f:close ()
  end


function tsv_lines (f)    ------------------------------------------- tsv_lines
  f = type (f) == 'string' and io.open (f) or f
  local next_line = f:lines ()
  local function it ()
    local line = next_line ()
    line = line and pzp.explode ('\t', line)
    return line
    end
  return it
  end


function tsv_select (path, arg1, arg2, o)    ----------------------- tsv_select

          -- parse args
  local columns, where
  o = type (o) == 'string' and { index = o } or optionize (o)
  local t1, t2 = type (arg1), type (arg2)
          -- parse arg1
  if t1 == 'function' then  o.filter = arg1
  else if t1 == 'nil' or t1 == 'string' or t1 == 'table' then  columns = arg1
  else  error ('tsv_select: arg #1 has invalid type: '..t1)
    end  end
          -- parse arg2
  if t2 == 'function' then  o.filter = arg2
  else if t2 == 'string' then  o.index = arg2
  else if t2 == 'nil' or t2 == 'table' then  where = arg2
  else  error ('tsv_select: arg #2 has invalid type: '..t2)
    end  end  end

  local f = assert (io.open (path))
  local column_names = pzp.explode ('\t', f:read ())
  local flip = pzp.array_flip (column_names)

  columns = columns or '*'
  local expand = type (columns) == 'table'

  local result = {}
  for line in f:lines () do

            -- raw contains all the columns
    local raw = pzp.explode ('\t', line)
    for i,name in ipairs (column_names) do  raw[name] = raw[i]  end

            -- row contains only the selected columns
    local row = expand and {}
    if columns == '*' then  row = raw
    else if expand then
      for i,name in ipairs (columns) do
        local value = raw[flip[name]]
        row[name] = value
        append (row, value)
        end
    else  row = raw[flip[columns]]  end  end

            -- as needed: filter, index, and append
    if not o.filter or o.filter (raw, row, result) then
      if o.index then  result[raw[o.index]] = row  end
      if o.group then
        local k = raw[o.group]
        result[k] = result[k] or {}
        append (result[k], row)
        end
      if o.array or not o.index and not o.group then  append (result, row)  end
      end  end

  f:close ()
  return result
  end


function tsv_write (path, t)    ------------------------------------- tsv_write
  local f = io.open (path, 'w')
  for row in values (t) do
    if type (row) == 'table' then  row = table.concat (row, '\t')  end
    f:write (row..'\n')
    end
  f:close ()
  end


function tsv_decode (s)    ------------------------------------------ urldecode
  local function f (s)
    if s == '`' then  return '`'  end
    return char (tonumber (s, 16))
    end
  return string.gsub (s, '`(%w?[`%w])', f)
  end


function tsv_encode (s)    ------------------------------------------ urlencode
  local function f (s)
    if s == '`' then  return '``'  end
    return '`'..format ('%02x', byte (s))
    end
  return string.gsub (s, '[`\n\r\t]', f)
  end


function values (t)    ------------------------------------------------- values
  local k, v
  return function ()  k, v = next (t, k)  return v  end
  end
