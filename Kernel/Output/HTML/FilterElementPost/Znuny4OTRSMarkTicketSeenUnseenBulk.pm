# --
# Copyright (C) 2012-2016 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FilterElementPost::Znuny4OTRSMarkTicketSeenUnseenBulk;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %ParamLabel = (
        MarkTicketsAsSeen   => "Mark tickets as seen",
        MarkTicketsAsUnseen => "Mark tickets as unseen",
    );

    PARAM:
    for my $CurrentParam (qw( MarkTicketsAsSeen MarkTicketsAsUnseen )) {

        my $CurrentParamValue = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $CurrentParam );

        my $SelectHTML = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
            Data       => $Kernel::OM->Get('Kernel::Config')->Get('YesNoOptions'),
            Name       => $CurrentParam,
            SelectedID => $CurrentParamValue || 0,
        );

        my $CurrenParamTranslation = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}
            ->Translate( $ParamLabel{$CurrentParam} );
        my $ElementHTML = <<HTML;
                        <label for="$CurrentParam">$CurrenParamTranslation:</label>
                        <div class="Field">
                            $SelectHTML
                        </div>
                        <div class="Clear"></div>
HTML

        ${ $Param{Data} } =~ s{(</fieldset>[^<]+</div>[^<]+</div>[^<]+<div \s class="Footer")}{$ElementHTML$1}xms;
    }

    return 1;
}

1;
