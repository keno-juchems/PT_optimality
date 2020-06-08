    function PT_prob = get_pt_prob(p,gamma)
        numerator = p.^gamma;
        denominator = (numerator + (1-p).^gamma).^(1./gamma);
        PT_prob = numerator ./ denominator;
    end