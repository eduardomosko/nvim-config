local header = require 'header42'

header.user = "emendes-"
header.mail = "@students.42sp.org.br"

-- Bash and Python
header.types['\\.sh$\\|\\.py$'] = {'#', '*', '#'}
