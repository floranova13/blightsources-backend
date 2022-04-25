DROP TABLE IF EXISTS prices;
DROP TABLE IF EXISTS blightsources;
DROP TABLE IF EXISTS subcategories;
DROP TABLE IF EXISTS categories;

DROP TYPE IF EXISTS FLUX;

CREATE TYPE FLUX AS ENUM ('volatile', 'fluid', 'stable', 'fixed');

CREATE TABLE categories (
  id SERIAL PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  description TEXT[]
);

CREATE TABLE subcategories (
  id SERIAL PRIMARY KEY NOT NULL,
  category_id SERIAL REFERENCES categories (id),
  name TEXT NOT NULL,
  description TEXT[]
);

CREATE TABLE blightsources (
  id SERIAL PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  category_id SERIAL REFERENCES categories (id),
  subcategory_id SERIAL REFERENCES subcategories (id),
  description TEXT[],
  rarity INT NOT NULL
);

CREATE TABLE prices(
  blightsource_id SERIAL PRIMARY KEY REFERENCES blightsources (id),
  base_price INT NOT NULL,
  price_history INT[], /* https://www.postgresql.org/docs/current/intarray.html */
  volatility FLUX DEFAULT 'volatile'
);

INSERT INTO categories (name, description)
VALUES
    ('blightstones', ARRAY [ 'Blightstones are materials ranging from the metals smelted from blightfoils, to the crystal clusters of semi-transparent crystali, to the dense leylode deposits. They are more easily found in desert, tundras, and marine biome festerfonts. Conversely, they are less likely to be found in grassland biome festerfonts.', 'Blightstones are primarily harvested using miner''s picks, or jeweler''s chisels for the more delicate Crystali. Some guilds, however, have the resources to equip their harvesters with magitech harvesting tools, or equipment of wholly mechanical make. These guilds are few and far between, and they are discouraged by regular losses to blightbeasts, or high maintenance costs of expensive and fickle equipment.']),
    ('blightichors', ARRAY [ 'Blightichors are materials ranging from the vital lifeblight, to the viscous and toxic blightvenoms, to the thick and madness-inducing blightmares. They are more easily found in tundra and freshwater biome festerfonts. Conversely, they are less likely to be found in desert and marine biome festerfonts.', 'Blightichors  are primarily harvested using long tubes that suck the liquid into metal or ceramic tanks. Depending on the blightichor in question, the process can be extremely dangerous. Leaks in an old or ill-suited tank can expose the harvester to the contents, and though harvesters wear suits and head coverings to protect themselves from their cargo, liquid can seep in and affect the harvester anyway. Affected harvesters can die, become have their cognition permanently altered, and a host of other tragedies can befall them.' ]),
    ('blightfumes', ARRAY [ 'Blightfumes are materials ranging from the performance-altering rushblight, to efficiently-lethal miasmeta, to variable and far-ranging blightmists. They are more easily found in desert and freshwater biome festerfonts. Conversely, they are less likely to be found in grassland and marine biome festerfonts. These gases leak out of festerfonts, and aren''t always easy to collect.', 'The gaseous blightfumes are are primarily acquired by specialized harvesters nicknamed ''palemasks''. Palemasks wear self-fashioned to protect them from the fumes they collect, and are often interesting characters, unavoidably inhaling enough of their own product over their work to manifest any number of mental disorders. Acute or chronic, it depends how prone they are to checking their suits for breaches on a regular basis, and how tempted they are to intentionally inhale their own product. Many end up dead before they know it.']),
    ('blightflora', ARRAY [ 'Blightflora resemble plants, though they appear to interact differently with the established natural laws, much like the very Festerfonts that spawn them. They must be harvested carefully to obtain the valuable parts. If the whole plant is desired, it is even more difficult to store it while in transit and harder still to keep it alive. If a blightflora somehow successfully makes it back to a lab without wilting, it must regularly suckle blight energy to ''live'' on. Most harvesters will not bother learning to collect them, reasonably deeming them more trouble than they''re worth. They are less likely to be found in desert biome festerfonts, but other biomes contain them in ample supply.', 'Some blightflora exhibit incredible properties, though this category of blightsource is surprisingly varied, so pinning down which variant of blightbloom or blightsnarl has which characteristic can be difficult. This difficulty is compounded by the festerfonts they spawn in, making them inherently difficult to document safely. However, There will always be reckless fools who try to collect them for sport, and it is these hobbyists who are in the best position to contribute to a more comprehensive image of blightflora variability.']),
    ('blightfungi', ARRAY [ 'Blightfungi resemble fungi of the natural world, though the similarities often end upon close examination. They are often parasitic in nature, leeching resources in a specific way (e.g blightshrooms). Another trait drawn under this umbrella is the ability to self-replicate, such as with the sporesprawls. Blight researchers were initially very interested in studying what they thought were ''docile blightbeasts'', only to then learn that they were not blightbeasts at all. Later still, blightbleeds were discovered, and self-preservation saw the number of eager scientists lining up to journey into festerfonts to seek out blightfungi dwindle to a small trickle.', 'Though blightsources and most definitely not blightbeasts, blightfungi are dangerous in an environment where a seeker''s resources preserve their lives. Exhausted resources due to a poorly situated camp, such as one in a cluster of blightshrooms, is yet another threat to contend with out on contract. Blightfungi are commonly found in all festerfont biomes save for deserts.']),
    ('blightanomalies', ARRAY [ 'The blightanomalies are bizarre oddities that only appear in festerfonts. Very little is known about them. They are prized by collectors, who believe they grant special powers, once unlocked. However, there has yet to be any scientific test that measured any such boon being granted by one of these objects. Though certain tests can confirm whether an object actually is a blightanomaly or if it is just a fake. Every single blightanomaly is unique, though some have similar powers.', 'Given that cults have sprung up upon the discovery of these objects, blightanomalies aren''t so much harvested as they are collected and safely secured. Some have seen use as special tools of power, but only the government and the Blightbane Guild can authorize such uses. Blightanomalies aren''t found in greater or lesser quantities in any particular biome. That is to say, they are extremely rare in any biome.']);

WITH ins (name, category_name, description) AS
( VALUES
  ( 'blightfoils', 'blightstones', ARRAY ['Blightfoils are metals smelted from minerals carrying inherently magical qualities. One would think that this would make such materials exceptionally valuable, but it is not so. Their worth is inflated due to the metals being difficult to work with and even more difficult to find a use for. Predicting how a blightfoil will interact with any given spell is tricky. Mages are notoriously reckless, but who uses a blightfoil catalyst is going a step further than the norm in regards to disregard for personal safety.', 'The most popular blightfoil would have to be forslone, which effectively cloaks the bearer in a magically repellant shield. It is more complicated than that, but defense against magic is one thing anyone will upend their coin purses for. Other metals are sometimes used for decoration, such as the beautiful voidshimmer, with its midnight black base, full of everlasting purple sparkles.']),
  ( 'crystali', 'blightstones', ARRAY ['Crystali are found in fragile clusters, often glittering in the caves of festerfonts, far off the beaten path. They are unique for their ability to store and expel magical energy. For this reason, they are used as vessels for energy, and portable spell containers. Some crystali are durable enough to expend the stored spell multiple times, but these are rare, and most simple shatter once they are used.', 'As disposable as these materials are, a merchant is always willing to buy one, no matter how small the crystal fragment may be. Harvesting them is no easy task. They are prone to shattering at the lightest touch. That goes doubly for using them to store a spell. Commonly, vitality and clarity shards are formed from small crystals of apertrite, which is the least expensive crystali on the market.']),
  ( 'leylodes', 'blightstones', ARRAY ['Leylodes are dense deposits found in the depths of festerfont rock, or less commonly, on the surface said blighted land. Though festerfonts spawn blightbeasts and blightsources seemingly randomly and spontaneously, leylodes have been observed to proliferate from existing deposits. In this way, a harvest crew can leave a small portion of easily-accessible leylode untouched, until it grows enough to tap into once more. That is, if another crew hasn''t gotten their first.', 'Harvesting leylodes is easy enough, as the real chore is transporting any sizable quantity out of the festerfont and getting a good price for it. Fortunately, the price of charke, the most commonly encountered leylode, is always high enough to make it worth the effort. The Guild will always buy other leylodes, especially curos, for which they remain the sole buyer.']),
  ( 'lifeblight', 'blightichors', ARRAY ['Used in the creation of restoratives, this is a peculiar category of liquids. Lifeblight flow with low viscosity, much more like water than the sludge some other blightichors are. Of all the blightichors, lifeblight is the most valuable, as most people prioritize safety. For this reason, harvesters will selectively seek lifeblight when harvesting blightichors, leading to fierce competition over easy-to-tap wells and fresh springs.', 'Interestingly enough, in dangerous festerfonts where easily-processed lifeblight can be found, it''s wise to bring along a portable harvest and processing kit for mid-contract rejuvenation. Even crudely processed lifeblight can be the difference between life and death, when you''re party is cornered and running low on everything.']),
  ( 'blightvenoms', 'blightichors', ARRAY ['Blightvenoms are much more viscous than lifeblight. They are used to make dangerous concoctions and blade coatings. The difference between treatment and toxin is sometimes a fine line in medicine, but this is not the case with blightvenoms. Almost all of these festerfont secretions are poisons, plain and simple. Gatherers of blightvenoms are an odd sort, even among seekers. They stand out, rarely bonding with their defending seekers, and their closest friends are usually other blightvenom harvesters and the deathdealers whom they sell to.', 'National restrictions on trade, even within the increasingly authoritarian nation of Shroud, are still in their infancy. For this reason, trade in poisons are still going strong. This is especially the case with ill-understood substances, like most blightsources. That said, authorities ''in the know'' will still lean heavily on deathdealers and harvesters, often forcing them to play down their specialties, to varying effect. Some are simply ill-suited to such deceptions.']),
  ( 'blightmares', 'blightichors', ARRAY ['Blightmares are a rare blightichor variant. It is like very thick molasses, with chemical properties far more varied than other blightichors. One thing all blightmares share is an alteration of perception on the target. Sometimes, a concoction will make use of the beneficial properties of this altered perception, at the cost of detrimental affects. It is difficult to argue that any given blightmare is entirely harmless. A willing subject may tolerate the affects of a blightmare, but they do so at their own risk.', 'This blightichor variant is named after an ancient belief that the Blight contains many trickster spirits. Supposedly, these spirits enjoy toying with sapient creatures, delighting in their reactions. Most civilized parts of Shroud have shrugged off such superstitions, in large part motivated by cultural purges conducted by knights and enforcers, but wilderness villages will sometimes conduct rituals using blightmares to commune with spirits, exchanging drug-borne entertainment for whatever the wants of the villagers may be. Sometimes, there are even rumors of spirits granting these requests.']),
  ( 'rushblight', 'blightfumes', ARRAY ['Rushblight are fumes inhaled by those who want to alter their performance, or are maybe just looking for an expensive high. The long-term effect of these chemicals is unknown, but that doesn''t stop seekers from using it out in the field. It doesn''t matter, so long as they can surpass normal limits in the short term. There is always a tradeoff in using rushblight to perform. The consequences of a crash at the wrong time can lead to death, and it can also be death, depending on the inhalant. Sometimes, seekers will carry a dose of rushblight to take if things get chancy, only to take if they find their back against the wall.', 'Addiction abounds in competitive seeker markets. When seekers need to be nearly immortal just to make a living, it leads to people trying to find any edge they can, just to survive. When stress and tight budgets cause riskier and riskier behavior, a seeker relying on rushblight to make ends meet might have to quit the profession. However, it doesn''t end there. They are reliant on rushblight, even if it is no longer necessary for them. Rushblight is expensive, so these ex-seekers turn to crime to buy more, and it only goes poorly from there.']),
  ( 'miasmeta', 'blightfumes', ARRAY ['As the name implies, these blightfumes are dangerous to inhale. They have few applications save to kill biological organisms. This is not, in fact, a misspelling of miasmata. It alludes to what researchers classify as a ''self-referential'' nature of the Blight Miasma''s as it annihilates a subject.', 'Miasmeta is highly reactive to external stimuli, and to itself, allowing a festerfont to ''tune'' Miasmeta to kill a marked target that it''s own blightbeasts cannot kill themselves. This was a horrifying discovery, but there is a sliver of hope within this deadly material. If sapient organisms could somehow tune miasmeta themselves, they could turn it back on the Blight. However, where this possible, there would be no stopping ambitious and morally flexible scientists from turning it back on an enemy nation or population.']),
  ( 'blightmists', 'blightfumes', ARRAY ['These blightfumes cover a wide area with low-density gaseous particles. These particles alter the properties of magical energies that enter their area of influence. This alteration is predictable, to some extent. Blightmists can be released to protect a group from dangerous magic, nullifying it. An area can also be coated in a mist that alters magic for offensive purposes. Additionally, it can be used in technology to make certain reactors function as intended.', 'Given the diverse applications of blightmists, they are valuable desirable to research and manufacturing guilds, and therefore traded in high quantities. This is a period of great discovery and interest in further applications of blightsources, with blightmists are among the most sought-out materials.']),
  ( 'blightblooms', 'blightflora', ARRAY ['A blightbloom is a flowering plant that is produced and sustained by the Festerfont. They share a strange property with the festerfonts themselves, very slowly drawing energy from some unknown source. Scientists are fervently studying how this energy might be harvested, though there have been no successful attempts.', 'These blightflora are commonly compared to flourishflora, though they aren''t very alike at all. Unlike flourishflora, a blightbloom requires no vira to sustain itself, and generates no vira. Instead, like all blightsources, they appear to be a physical manifestation of leaked blight energy. In turn, warped blight energy is all a blightbloom provides.']),
  ( 'blightpillars', 'blightflora', ARRAY ['Blightpillars closely resemble trees, but they are produced and sustained by a festerfont''s blight energies, and thus, can only grow upon one. They can be cut down to obtain wood with strange properties. Many use this wood for innovative purposes.', 'Axes work just as well on blightpillars as they do on normal trees, though inferior materials will quickly wear through. Another concern is that the sound of a blightpillar being felled announces the harvest party''s presence, attracting nearby blightbeasts. There has not, to date, ever been a documented case of a harvester successfully collecting a living blightpillar specimen. At least, not one that lived long once it was replanted outside a festerfont.']),
  ( 'blightsnarls', 'blightflora', ARRAY ['These blightflora consist of bodies called ''soma'', which produce extensions of different tissue called ''axons''. These two parts form intricate webs together with other members of a community of blightsnarls. Experimentation with active networks of blightsnarls reveal that they are capable of transmitting signals relating to resource locations and threats to their environment, across the network, and thereby guide the future development of the network. A blightsnarl does not need any of the resources it discovers. The function of the mapping behavior is unclear.', 'One recent revelation is that blightsnarls only appear within ''command'' configuration festerfonts, or where there are nearby neighboring command festerfonts. Disrupting blightsnarl networks growing around a festerfont will hinder the ability for a command festerfont to communicate with its neighbors, though, it is only one such communication mechanism a command type employs. Researchers believe blightsnarls will eventually be harvested for use in pseudo-biological computation technology, using the material''s innate networking specialization to allow sentients to communicate across vast distances. There is also further speculation on whether artificial representations could be made possible through study.']),
  ( 'blightshrooms', 'blightfungi', ARRAY ['A blightshroom bears a resemblance to a mushroom, including cap and mycelium structures. However, it is typically sustained by a festerfont''s energies, though it can be supplied with an alternate food source. Most are very efficient at extracting certain nutrients from whatever they grow on. In some cases, festerfonts develop to reclaim this energy through some yet-unknown method.', 'Blightshrooms can be harvested and used to extract nutrients from various surfaces, including the very ground, though it is difficult for researchers to predict what will be extracted, and varying results leads to disappointments. Hope for more practical applications remain strong, at least for some blightfungi materials.']),
  ( 'blightbleeds', 'blightfungi', ARRAY ['A blightbleed is a type of blightfungus that grows on a living thing, taking the appearance of a bubbling jelly. It is named after a particularly ugly appearance, as if Blighted blood drips from the host. Coloration of this ''blood'' depends on the specimen in question, and also upon the host it has attached itself to.', 'Sometimes, a blightbleed can be useful for its mutualistic relationship with the organic matter that hosts it. Normally, a human or any such intelligent species would not be crazy enough to willingly allow the Blight to grow on them, but some eccentric seekers or civilians have cultivated blightbleed on their bodies to augment their abilities. Ironically, later discoveries reveal that a person integrated with a blightbleed growth is more resistant to the harmful mental effects of the Blight Malady.']),
  ( 'sporesprawls', 'blightfungi', ARRAY ['A sporesprawl is a rare type of blightfungi that will remain dormant in a pod-like structure, passively feeding on whatever stray energy is nearby, until it activates and begins producing spores at an explosive rate. These spores then begin to spread a spongy growth wherever they touch down, forming the substance that could be considered the second stage manifestation of the sporesprawl. Finally, the spongy growth starts to decay, receding back into freshly formed pods, accumulating in areas with the highest resource availability. This process is excessively disruptive to the surrounding environment, puzzling researchers.', 'Harvesters and combat seekers alike avoid areas where sporesprawls are known to be active. It is not a pleasant experience to have your body''s vitality sapped away with every step you take, worse still when you find that coexisting blightbeasts all have traits that make them suited to operate in such environments.']),
  ( 'tokens', 'blightanomalies', ARRAY ['Tokens are the most commonly found category of blightanomaly, but that in no way means they are easy to find. Often, their effects are subtle enough to write off as tricks of the mind, lies, or any such natural occurrence.', 'Samples from this category of blightanomaly are often studied in earnest. If a firm confidence can be reached in a token''s power, they can be authorized for use in festerfont purges and such high-threat engagements.']),
  ( 'loci', 'blightanomalies', ARRAY ['Loci are moderate-strength blightanomalies. They are rarer than tokens, but that hasn''t stopped them from causing a lot of damage over the years.', 'These are only rare authorized for use by the Blightbane Branch leader responsible for securing them, usually only in an emergency, and only when the effect of the locus is well documented.']),
  ( 'vestiges', 'blightanomalies', ARRAY ['Vestiges are extraordinarily rare blightanomalies which have the capability to cause massive disruptions to everyday life. The spread of this chaos can be as small as only the holder, or in most cases, as unrestrained as to spread to a wide area and engulf hundreds in the effect.', 'The name is a reference to the Orchestrators, but few know that. The Blightbane Guild has a standing order to acquire and contain any known vestiges, as their use is strictly forbidden without the national Blightbane Guild leader''s approval. Shroud''s leadership has such an order too, but they have yet to make the connection between the rare appearance of such an object and The Blight. Maybe if they did, they wouldn''t ignore the threat the phenomenon poses.'])
)  
INSERT INTO subcategories
  (name, category_id, description) 
SELECT 
  ins.name, categories.id, ins.description
FROM 
  categories JOIN ins
    ON ins.category_name = categories.name;

WITH ins (name, subcategory_name, rarity) AS
( VALUES
  ( 'forslone', 'blightfoils', 27),
  ( 'erecombe', 'blightfoils', 9),
  ( 'voidshimmer', 'blightfoils', 1),
  ( 'apertrite', 'crystali', 27),
  ( 'meartite', 'crystali', 9),
  ( 'digitrite', 'crystali', 1),
  ( 'charke', 'leylodes', 27),
  ( 'amplare', 'leylodes', 9),
  ( 'curos', 'leylodes', 1),
  ( 'rigorvat', 'lifeblight', 27),
  ( 'purivat', 'lifeblight', 9),
  ( 'mirivat', 'lifeblight', 1),
  ( 'perceptyde', 'blightvenoms', 27),
  ( 'residux', 'blightvenoms', 9),
  ( 'falefate', 'blightvenoms', 1),
  ( 'blissburn', 'blightmares', 27),
  ( 'red agony', 'blightmares', 9),
  ( 'pulsepox', 'blightmares', 1),
  ( 'mystic', 'rushblight', 27),
  ( 'surge', 'rushblight', 9),
  ( 'edge', 'rushblight', 1),
  ( 'lasperr', 'miasmeta', 27),
  ( 'manaphage', 'miasmeta', 9),
  ( 'ominox', 'miasmeta', 1),
  ( 'nullmist', 'blightmists', 27),
  ( 'magnimist', 'blightmists', 9),
  ( 'intermist', 'blightmists', 1),
  ( 'shrineflower', 'blightblooms', 27),
  ( 'hydrobloom', 'blightblooms', 9),
  ( 'shimmering nightblight', 'blightblooms', 1),
  ( 'whitespire', 'blightpillars', 27),
  ( 'greyspire', 'blightpillars', 9),
  ( 'blackspire', 'blightpillars', 1),
  ( 'silverclutch', 'blightsnarls', 27),
  ( 'wenderweave', 'blightsnarls', 9),
  ( 'darkcoil', 'blightsnarls', 1),
  ( 'flushpod', 'blightshrooms', 27),
  ( 'metashroom', 'blightshrooms', 9),
  ( 'tranceloom', 'blightshrooms', 1),
  ( 'trickelpus', 'blightbleeds', 27),
  ( 'rockmole', 'blightbleeds', 9),
  ( 'achromatic ooze', 'blightbleeds', 1),
  ( 'sporesprawl1', 'sporesprawls', 27),
  ( 'sporesprawl2', 'sporesprawls', 9),
  ( 'sporesprawl3', 'sporesprawls', 1),
  ( 'dusk orb', 'tokens', 27),
  ( 'token2', 'tokens', 9),
  ( 'token3', 'tokens', 1),
  ( 'locus1', 'loci', 27),
  ( 'locus2', 'loci', 9),
  ( 'locus3', 'loci', 1),
  ( 'lightmare prism', 'vestiges', 27),
  ( 'vestige2', 'vestiges', 9),
  ( 'vestige3', 'vestiges', 1)
)  
INSERT INTO blightsources
  (name, category_id, subcategory_id, rarity) 
SELECT 
  ins.name, subcategories.category_id, subcategories.id, ins.rarity
FROM subcategories
JOIN ins
  ON ins.subcategory_name = subcategories.name;

WITH ins (name, base_price, price_history, volatility) AS
( VALUES
  ( 'forslone', 9, ARRAY [1], 'stable'),
  ( 'erecombe', 495, ARRAY [1], 'stable'),
  ( 'voidshimmer', 711, ARRAY [1], 'stable'),
  ( 'apertrite', 9, ARRAY [1], 'stable'),
  ( 'meartite', 495, ARRAY [1], 'stable'),
  ( 'digitrite', 711, ARRAY [1], 'stable'),
  ( 'charke', 9, ARRAY [1], 'stable'),
  ( 'amplare', 495, ARRAY [1], 'stable'),
  ( 'curos', 711, ARRAY [1], 'stable'),
  ( 'rigorvat', 9, ARRAY [1], 'stable'),
  ( 'purivat', 495, ARRAY [1], 'stable'),
  ( 'mirivat', 711, ARRAY [1], 'stable'),
  ( 'perceptyde', 9, ARRAY [1], 'stable'),
  ( 'residux', 495, ARRAY [1], 'stable'),
  ( 'falefate', 711, ARRAY [1], 'stable'),
  ( 'blissburn', 9, ARRAY [1], 'stable'),
  ( 'red agony', 495, ARRAY [1], 'stable'),
  ( 'pulsepox', 711, ARRAY [1], 'stable'),
  ( 'mystic', 9, ARRAY [1], 'stable'),
  ( 'surge', 495, ARRAY [1], 'stable'),
  ( 'edge', 711, ARRAY [1], 'stable'),
  ( 'lasperr', 9, ARRAY [1], 'stable'),
  ( 'manaphage', 495, ARRAY [1], 'stable'),
  ( 'ominox', 711, ARRAY [1], 'stable'),
  ( 'nullmist', 9, ARRAY [1], 'stable'),
  ( 'magnimist', 495, ARRAY [1], 'stable'),
  ( 'intermist', 711, ARRAY [1], 'stable'),
  ( 'shrineflower', 9, ARRAY [1], 'stable'),
  ( 'hydrobloom', 495, ARRAY [1], 'stable'),
  ( 'shimmering nightblight', 711, ARRAY [1], 'stable'),
  ( 'whitespire', 9, ARRAY [1], 'stable'),
  ( 'greyspire', 495, ARRAY [1], 'stable'),
  ( 'blackspire', 711, ARRAY [1], 'stable'),
  ( 'silverclutch', 9, ARRAY [1], 'stable'),
  ( 'wenderweave', 495, ARRAY [1], 'stable'),
  ( 'darkcoil', 711, ARRAY [1], 'stable'),
  ( 'flushpod', 9, ARRAY [1], 'stable'),
  ( 'metashroom', 495, ARRAY [1], 'stable'),
  ( 'tranceloom', 711, ARRAY [1], 'stable'),
  ( 'trickelpus', 9, ARRAY [1], 'stable'),
  ( 'rockmole', 495, ARRAY [1], 'stable'),
  ( 'achromatic ooze', 711, ARRAY [1], 'stable'),
  ( 'sporesprawl1', 9, ARRAY [1], 'stable'),
  ( 'sporesprawl2', 495, ARRAY [1], 'stable'),
  ( 'sporesprawl3', 711, ARRAY [1], 'stable'),
  ( 'dusk orb', 9, ARRAY [1], 'stable'),
  ( 'token2', 495, ARRAY [1], 'stable'),
  ( 'token3', 711, ARRAY [1], 'stable'),
  ( 'locus1', 9, ARRAY [1], 'stable'),
  ( 'locus2', 495, ARRAY [1], 'stable'),
  ( 'locus3', 711, ARRAY [1], 'stable'),
  ( 'lightmare prism', 9, ARRAY [1], 'stable'),
  ( 'vestige2', 495, ARRAY [1], 'stable'),
  ( 'vestige3', 711, ARRAY [1], 'stable')
)  
INSERT INTO prices
  (blightsource_id, base_price, price_history, volatility) 
SELECT 
  blightsources.id, ins.base_price, ins.price_history, FLUX(ins.volatility)
FROM 
  blightsources JOIN ins
    ON ins.name = blightsources.name;