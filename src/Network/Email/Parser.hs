{- arch-tag: E-Mail Parsing Utility
Copyright (C) 2004 John Goerzen <jgoerzen@complete.org>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-}

{- |
   Module     : Network.Email.Parser
   Copyright  : Copyright (C) 2004 John Goerzen
   License    : GNU GPL, version 2 or above

   Maintainer : John Goerzen <jgoerzen@complete.org> 
   Stability  : provisional
   Portability: portable

Parses an e-mail message

Written by John Goerzen, jgoerzen\@complete.org
-}

module Network.Email.Parser(flattenMessage)
where

import Language.RFC2234.Parse(crlf)
import Language.RFC2822.Parse hiding (Message)
import Network.Email.Message.Parser(RawMessage(..), digestMessage)
import Network.Email.Message.HeaderField(Header(..))
import qualified Network.Email.Message
import Text.ParserCombinators.Parsec
import Control.Monad.Error
import Text.ParserCombinators.Parsec.Error
import Text.ParserCombinators.Parsec.Pos(newPos)
import Data.String

{- | Given a 'Network.Email.Message.Message' object, \"flatten\"
it into a simple, non-hierarchical list of its component single parts.

Data associated with a multipart will be lost, but each single child component
of the multipart will be preserved.
-}
flattenMessage :: Network.Email.Message.Message -> 
                  [Network.Email.Message.Message]
flattenMessage x =
    case x of
       y@(Network.Email.Message.Singlepart {}) -> [y]
       y@(Network.Email.Message.Multipart {}) ->
           concatMap flattenMessage (Network.Email.Message.getParts y)
