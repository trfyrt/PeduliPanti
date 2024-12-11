<?php

namespace Dedoc\Scramble\Support\Type;

class VoidType extends AbstractType
{
    public function isSame(Type $type)
    {
        return $type instanceof static;
    }

    public function toString(): string
    {
        return 'void';
    }
}
